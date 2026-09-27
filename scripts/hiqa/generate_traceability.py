"""Generate the HIQA logical models, FSH mappings and traceability outputs.

Single source of truth:
  docs/sources/hiqa-2026/ep-elements.csv   HIQA facts (ID, conformance, cardinality, datatype)
  docs/hiqa-2026/mapping/ep-mapping.csv    IE Core side (profile, path, MS, status, notes)

Generated (do not edit by hand):
  input/fsh/logical/HIQAEPrescriptionLM.fsh
  docs/hiqa-2026/traceability-matrix.csv
  input/pagecontent/hiqa-traceability.md

Run from the repository root:  python scripts/hiqa/generate_traceability.py [--check]
With --check, nothing is written; exit code 1 if any generated file is out of date.
"""
import csv
import io
import os
import re
import sys
from collections import Counter, OrderedDict

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
CANONICAL = 'https://hl7-ie.github.io/medication-events/fhir'
STATUSES = ['Aligned', 'Partial', 'Gap', 'Prohibited (violated)', 'Prohibited (enforced)', 'N/A']

STANDARDS = {
    'ep': dict(
        prefix='EP', name='HIQAEPrescriptionLM', id='HIQAEPrescriptionLM',
        title='HIQA ePrescription and eDispensation Dataset (draft, Sept 2026)',
        doc='Draft National Standard for Electronic Prescriptions and Electronic Dispensations, v1.1 draft for public consultation, September 2026',
        headings={
            '1': ('patientDetails', 'Section 1. Patient Details'),
            '1.1': ('nameDetails', '1.1 Name Details'),
            '1.2': ('address', '1.2 Address'),
            '1.3': ('identifiers', '1.3 Identifiers Used in Health and Social Care'),
            '1.4': ('additionalDemographicDetails', '1.4 Additional Demographic Details'),
            '1.5': ('communicationDetails', '1.5 Communication Details'),
            '1.6': ('clinicalInformation', '1.6 Clinical Information'),
            '2': ('healthPractitionerDetails', 'Section 2. Health Practitioner Details'),
            '3': ('medicationPrescription', 'Section 3. Medication Prescription'),
            '3.6': ('notes', '3.6 Notes (heading not numbered in the source)'),
            '4': ('medication', 'Section 4. Medication'),
            '5': ('dosaging', 'Section 5. Dosaging'),
            '6': ('medicationDispense', 'Section 6. Medication Dispense'),
        },
        # Leaves with no HIQA datatype: type chosen here, rationale in the comment.
        overrides={
            '1.6.2.4.2': 'Reference(Practitioner or PractitionerRole or Patient or RelatedPerson)',
            '1.6.3.3.2': 'Reference(Practitioner or PractitionerRole or Patient or RelatedPerson)',
            '1.6.4.3.2': 'Reference(Practitioner or PractitionerRole or Patient or RelatedPerson)',
            '3.5.3': '@medication',
            '3.5.8': '@dosaging',
            '6.4.1': 'Reference(Patient)',
            '6.4.2': 'Reference(Practitioner or PractitionerRole)',
            '6.6': '@medication',
            '6.11': '@dosaging',
        },
    ),
}

DATATYPES = [
    (r'^coded value \(boolean\)$', 'boolean'),
    (r'^cod', 'CodeableConcept'),
    (r'^free ?text', 'string'),
    (r'^alpha', 'string'),
    (r'^numeric', 'string'),      # identifiers and phone numbers: keep leading zeros
    (r'^numerical$', 'integer'),
    (r'^integer$', 'integer'),
    (r'^decimal$', 'decimal'),
    (r'^datetime$', 'dateTime'),
    (r'^date$', 'date'),
    (r'^time$', 'time'),
    (r'^period$', 'Period'),
    (r'^quantity$', 'Quantity'),
    (r'^range$', 'Range'),
    (r'^ratio$', 'Ratio'),
    (r'^boolean$', 'boolean'),
    (r'^(attachment|multi-media)$', 'Attachment'),
]


def fhir_type(values):
    v = values.strip().lower()
    for pat, t in DATATYPES:
        if re.search(pat, v):
            return t
    raise ValueError(f'unmapped HIQA datatype: {values!r}')


def camel(name):
    name = re.sub(r'\((cluster|record entry|free text|coded|Cluster|Record Entry|Empty reason|empty reason)\)', '', name)
    name = name.replace('’', "'").replace('‘', "'")
    words = re.findall(r'[A-Za-z0-9]+', name)
    if not words:
        return 'element'
    out = words[0].lower() + ''.join(w[:1].upper() + w[1:].lower() for w in words[1:])
    if out[0].isdigit():
        out = 'e' + out
    return out[:48]


def fsh_str(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'


def read_csv(path):
    with open(os.path.join(ROOT, path), encoding='utf-8', newline='') as fh:
        return list(csv.DictReader(fh))


def id_key(i):
    return [int(p) for p in i.split('.')]


class Node:
    def __init__(self, hid, name, row=None, heading=None):
        self.hid, self.name, self.row, self.heading = hid, name, row, heading
        self.children = OrderedDict()
        self.path = None


def build_tree(std, rows):
    root = Node('', std['name'])
    nodes = {'': root}
    for hid in sorted(std['headings'], key=id_key):
        name, label = std['headings'][hid]
        nodes[hid] = Node(hid, name, heading=label)
    for r in rows:
        nodes[r['id']] = Node(r['id'], camel(r['element']), row=r)

    def parent_of(hid):
        parts = hid.split('.')
        while len(parts) > 1:
            parts = parts[:-1]
            if '.'.join(parts) in nodes:
                return nodes['.'.join(parts)]
        return root

    for hid in sorted((k for k in nodes if k), key=id_key):
        node, parent = nodes[hid], parent_of(hid)
        base, n = node.name, 2
        while node.name in parent.children:  # unique sibling names
            node.name = f'{base}{n}'
            n += 1
        parent.children[node.name] = node

    def assign(node, prefix):
        for child in node.children.values():
            child.path = f'{prefix}.{child.name}' if prefix else child.name
            assign(child, child.path)
    assign(root, '')
    return root, nodes


def element_rule(std, node, by_heading_name):
    pfx = std['prefix']
    if node.heading:
        return f'* {node.path} 0..1 BackboneElement {fsh_str(node.heading)} {fsh_str(node.heading + " (grouping heading; no HIQA conformance)")}'
    r = node.row
    card = r['cardinality'] or '0..*'
    if node.children:
        ftype = 'BackboneElement'
    elif r['id'] in std['overrides']:
        ftype = std['overrides'][r['id']]
    else:
        ftype = fhir_type(r['values'])
    applies = {'P': 'prescription record', 'D': 'dispensation record', 'PD': 'prescription and dispensation records'}.get(r['pd'], '')
    short = f'[{pfx} {r["id"]}] {r["element"]} ({r["conformance"]} {card})'
    definition = (f'HIQA {pfx} {r["id"]} {r["element"]}. Conformance: {r["conformance"]}. Cardinality: {card}. '
                  f'HIQA datatype: {r["values"] or "(none given)"}.'
                  + (f' Applies to: {applies}.' if applies else '')
                  + (' Expected to be auto-populated from another system.' if r['auto'] else '')
                  + f' Source: HIQA {std["doc"]}, p. {r["page"]}.')
    if ftype.startswith('@'):
        target = by_heading_name[ftype[1:]]
        # The fragment is an element id; SUSHI roots logical-model element ids at the Id, not the Name.
        # Ids are alphanumeric so element paths satisfy eld-20.
        return (f'* {node.path} {card} contentReference {CANONICAL}/StructureDefinition/{std["id"]}#{std["id"]}.{target} '
                f'{fsh_str(short)} {fsh_str(definition)}')
    return f'* {node.path} {card} {ftype} {fsh_str(short)} {fsh_str(definition)}'


def generate_fsh(std, root, nodes, mapping):
    by_heading_name = {n.name: n.path for n in nodes.values() if n.heading}
    out = io.StringIO()
    w = out.write
    w('// ╭──────────────────────────────────────────────────────────────────────╮\n')
    w(f'// │  GENERATED by scripts/hiqa/generate_traceability.py. Do not edit.     │\n')
    w('// │  Source: docs/sources/hiqa-2026 + docs/hiqa-2026/mapping             │\n')
    w('// ╰──────────────────────────────────────────────────────────────────────╯\n\n')
    w(f'Logical: {std["name"]}\n')
    w(f'Id: {std["id"]}\n')
    w(f'Title: {fsh_str(std["title"])}\n')
    w(f'Description: {fsh_str("Logical model of the HIQA " + std["doc"] + ". Built only from the element IDs, conformance, cardinality and datatypes published in the draft. Coded values are not specified by HIQA. This is a consultation draft and will change. Not endorsed by HIQA.")}\n')
    w('Characteristics: #can-be-target\n')
    w('* ^status = #draft\n* ^experimental = true\n')
    w('* ^publisher = "Nithin Mohan T K (Proof of Concept)"\n\n')

    def walk(node):
        for child in node.children.values():
            w(element_rule(std, child, by_heading_name) + '\n')
            walk(child)
    walk(root)

    w(f'\nMapping: {std["name"]}ToIECore\n')
    w(f'Source: {std["name"]}\n')
    w(f'Target: "{CANONICAL}"\n')
    w('Id: ie-core\n')
    w('Title: "IE Core profiles"\n')
    w(f'Description: "How each HIQA {std["prefix"]} element is represented in IE Core. GAP = not represented."\n')
    for hid in sorted((k for k in nodes if k and nodes[k].row), key=id_key):
        m = mapping[hid]
        target = f'{m["profile"]}: {m["path"]}' if m['path'] else 'GAP'
        comment = f'{m["status"]}' + (f'. {m["notes"]}' if m['notes'] else '')
        w(f'* {nodes[hid].path} -> {fsh_str(target)} {fsh_str(comment)}\n')
    return out.getvalue()


def main(check=False):
    outputs = {}
    matrix = []
    problems = []
    for key, std in STANDARDS.items():
        rows = read_csv(f'docs/sources/hiqa-2026/{key}-elements.csv')
        maprows = read_csv(f'docs/hiqa-2026/mapping/{key}-mapping.csv')
        mapping = {m['hiqa_id']: m for m in maprows}
        ids = {r['id'] for r in rows}
        for i in ids - set(mapping):
            problems.append(f'{std["prefix"]} {i}: no mapping row')
        for i in set(mapping) - ids:
            if not i.startswith('NA-'):
                problems.append(f'{std["prefix"]} {i}: mapping row for an unknown HIQA element')
        for m in maprows:
            if None in m or any(v is None for v in m.values()):
                problems.append(f'{std["prefix"]} {m.get("hiqa_id")}: malformed CSV row (quote notes that contain commas)')
                continue
            if m['status'] not in STATUSES:
                problems.append(f'{std["prefix"]} {m["hiqa_id"]}: invalid status {m["status"]!r}')
            if m['status'] == 'Gap' and m['path']:
                problems.append(f'{std["prefix"]} {m["hiqa_id"]}: Gap must have an empty path')
        if problems:
            continue
        root, nodes = build_tree(std, rows)
        outputs[f'input/fsh/logical/{std["name"]}.fsh'] = generate_fsh(std, root, nodes, mapping)
        for r in sorted(rows, key=lambda r: id_key(r['id'])):
            m = mapping[r['id']]
            matrix.append(dict(standard=std['prefix'], hiqa_id=r['id'], element=r['element'], applies_to=r['pd'],
                               conformance=r['conformance'], cardinality=r['cardinality'], hiqa_datatype=r['values'],
                               profile=m['profile'], path=m['path'], ms=m['ms'], status=m['status'], notes=m['notes'],
                               lm_path=f'{std["name"]}.{nodes[r["id"]].path}'))
        for m in maprows:
            if m['hiqa_id'].startswith('NA-'):
                matrix.append(dict(standard=std['prefix'], hiqa_id='—', element=m['hiqa_id'][3:], applies_to='',
                                   conformance='Not in dataset', cardinality='0..0', hiqa_datatype='',
                                   profile=m['profile'], path=m['path'], ms=m['ms'], status=m['status'],
                                   notes=m['notes'], lm_path=''))
    if problems:
        print('\n'.join(problems), file=sys.stderr)
        return 1

    buf = io.StringIO()
    fields = ['standard', 'hiqa_id', 'element', 'applies_to', 'conformance', 'cardinality', 'hiqa_datatype',
              'profile', 'path', 'ms', 'status', 'notes', 'lm_path']
    cw = csv.DictWriter(buf, fieldnames=fields, lineterminator='\n')
    cw.writeheader()
    cw.writerows(matrix)
    outputs['docs/hiqa-2026/traceability-matrix.csv'] = buf.getvalue()
    outputs['input/pagecontent/hiqa-traceability.md'] = render_page(matrix)

    stale = []
    for rel, content in outputs.items():
        path = os.path.join(ROOT, rel)
        current = open(path, encoding='utf-8').read() if os.path.exists(path) else None
        if current != content:
            stale.append(rel)
            if not check:
                os.makedirs(os.path.dirname(path), exist_ok=True)
                with open(path, 'w', encoding='utf-8', newline='\n') as fh:
                    fh.write(content)
    if check and stale:
        print('Out of date (run scripts/hiqa/generate_traceability.py):\n  ' + '\n  '.join(stale), file=sys.stderr)
        return 1
    print(('checked' if check else 'wrote') + f' {len(outputs)} files; {len(matrix)} matrix rows')
    return 0


def md(s):
    return (s or '').replace('|', '\\|')


def render_page(matrix):
    out = io.StringIO()
    w = out.write
    w('<!-- GENERATED by scripts/hiqa/generate_traceability.py. Do not edit. -->\n\n')
    w('This page traces every data element in the HIQA Draft National Standard for Electronic Prescriptions and\n'
      'Electronic Dispensations (September 2026) to where it is represented in IE MPD. It is generated from the\n'
      'committed mapping sources, so the IG and this table cannot drift apart.\n\n')
    w('<div class="note-to-balloters" markdown="1">\n\n**Status: based on a consultation draft.** The HIQA standard is a draft for public consultation\n'
      '(closing 21 October 2026) and will change. This IG is a proof of concept with no affiliation with HIQA, the HSE, HL7 Ireland,\n'
      'HL7 Europe or the Department of Health.\n\n</div>\n\n')
    w('**Status values:** *Aligned*: represented, with cardinality and MustSupport consistent with HIQA conformance. '
      '*Partial*: represented, but cardinality, MustSupport, binding or semantics differ (see notes). '
      '*Gap*: not represented. *Prohibited (violated / enforced)*: personal data that is **not** in the dataset for this use case '
      'and so must not be sent; "violated" means the IG still allows or encourages it. '
      '*N/A*: not applicable to a FHIR exchange.\n\n')
    w('**Conformance convention:** HIQA Mandatory → `min ≥ 1` + MustSupport; Required → MustSupport; Optional → allowed, no MustSupport.\n\n')
    w('Logical model: [HIQA ePrescription/eDispensation](StructureDefinition-HIQAEPrescriptionLM.html). '
      'Machine-readable matrix: `docs/hiqa-2026/traceability-matrix.csv` in the source repository.\n\n')
    w('### Summary\n\n')
    for std, label in [('EP', 'ePrescription / eDispensation')]:
        rows = [r for r in matrix if r['standard'] == std]
        w(f'**{label}** ({sum(1 for r in rows if r["hiqa_id"] != "—")} HIQA elements)\n\n')
        w('| Conformance | ' + ' | '.join(STATUSES) + ' |\n|---|' + '---|' * len(STATUSES) + '\n')
        for conf in ['Mandatory', 'Required', 'Optional', 'Not in dataset']:
            c = Counter(r['status'] for r in rows if r['conformance'] == conf)
            w(f'| {conf} | ' + ' | '.join(str(c.get(s, 0)) for s in STATUSES) + ' |\n')
        w('\n')
    w('### Mandatory elements not yet aligned\n\n| Std | HIQA ID | Element | Status | Notes |\n|---|---|---|---|---|\n')
    for r in matrix:
        if r['conformance'] == 'Mandatory' and r['status'] != 'Aligned':
            w(f'| {r["standard"]} | {r["hiqa_id"]} | {md(r["element"])} | {r["status"]} | {md(r["notes"])} |\n')
    for std, label in [('EP', 'ePrescription / eDispensation')]:
        w(f'\n### {label}: full matrix\n\n')
        w('| HIQA ID | Element | Conf. | Card. | Profile | Path | MS | Status | Notes |\n|---|---|---|---|---|---|---|---|---|\n')
        for r in matrix:
            if r['standard'] != std:
                continue
            pd = f' ({r["applies_to"]})' if r['applies_to'] else ''
            w(f'| {r["hiqa_id"]} | {md(r["element"])}{pd} | {r["conformance"]} | {r["cardinality"]} | {r["profile"]} | '
              f'`{md(r["path"])}` | {r["ms"]} | {r["status"]} | {md(r["notes"])} |\n'.replace('``', ''))
    return out.getvalue()


if __name__ == '__main__':
    sys.exit(main(check='--check' in sys.argv))
