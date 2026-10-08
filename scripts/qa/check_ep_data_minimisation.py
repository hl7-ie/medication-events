"""Guard: ePrescription / eDispensation content must not carry demographics outside the HIQA EP dataset.

Fails (exit 1) if any ePrescription or eDispensation example, payload, CDA document, Postman body or
test fixture mentions ethnicity, mother's maiden name, nationality, citizenship, religion or marital
status (ADR-002; GDPR Art. 5(1)(c) data minimisation; HIQA EP Section 1).

What counts as ePrescription/eDispensation content:
  * fsh-generated/resources: Patients claiming ie-mpd-patient-eprescription; MedicationRequest,
    MedicationDispense, Medication, List and Provenance examples; Bundles claiming an ePrescription profile.
  * input/fsh/examples/*.fsh: every Instance of IEMpdPatientEPrescription, the MedicationRequest/Dispense
    profiles and the ePrescription Bundles (checked in the FSH source too, so a failure points at the file).
  * input/examples/*.json|*.xml, input/postman/*.json, tests/**/fixtures: every file that contains a
    MedicationRequest or MedicationDispense (or a CDA ePrescription), except Patient Summary documents.
The Patient Summary (HIQA PS 1.4) legitimately carries ethnicity and nationality, so PS content is excluded.

Run: python scripts/qa/check_ep_data_minimisation.py   (run `sushi .` first for the generated checks)
"""
import glob
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
IE = 'https://hl7-ie.github.io/medication-events/fhir'
# Case-insensitive terms. 'ethnic' covers ethnicity / ethnicGroupCode; 'raceCode' is the CDA race element.
TERMS = re.compile(r'ethnic|racecode|maidenname|maiden.name|former.?surname|nationality|citizenship|religio|'
                   r'maritalstatus|marital.status|countryofaffiliation|country-of-affiliation', re.I)
EP_FSH_TYPES = ('IEMpdPatientEPrescription', 'IEMpdMedicationRequestEPrescription',
                'IEMpdMedicationDispenseEDispensation', 'IEMpdElectronicPrescriptionGroup',
                'IEMpdElectronicPrescriptionGroupCrossBorder', 'IEMpdListAllergiesAtPrescribing')
PS_MARKERS = ('60591-5', 'Composition', 'ClinicalDocument>', '<ClinicalDocument')


def is_ep_resource(r):
    profiles = (r.get('meta') or {}).get('profile') or []
    if r.get('resourceType') == 'Patient':
        return f'{IE}/StructureDefinition/ie-mpd-patient-eprescription' in profiles
    if r.get('resourceType') == 'Bundle':
        return any('bundle-eprescription' in p for p in profiles)
    return r.get('resourceType') in ('MedicationRequest', 'MedicationDispense')


def strip_narrative(node):
    """The terms may legitimately appear in human-readable descriptions; check data only."""
    if isinstance(node, dict):
        return {k: strip_narrative(v) for k, v in node.items() if k not in ('text', 'div', 'description', '_comment')}
    if isinstance(node, list):
        return [strip_narrative(x) for x in node]
    return node


def hits(text):
    return sorted({m.group(0) for m in TERMS.finditer(text)})


def main():
    problems = []

    gen = os.path.join(ROOT, 'fsh-generated', 'resources')
    checked_generated = 0
    for f in sorted(glob.glob(os.path.join(gen, '*.json'))):
        r = json.load(open(f, encoding='utf-8'))
        if r.get('resourceType') == 'StructureDefinition' or not is_ep_resource(r):
            continue
        checked_generated += 1
        h = hits(json.dumps(strip_narrative(r)))
        if h:
            problems.append(f'{os.path.relpath(f, ROOT)}: {", ".join(h)}')

    checked_fsh = 0
    for f in sorted(glob.glob(os.path.join(ROOT, 'input', 'fsh', 'examples', '*.fsh'))):
        text = open(f, encoding='utf-8').read()
        for block in re.split(r'\n(?=Instance:)', text):
            m = re.search(r'^InstanceOf:\s*(\S+)', block, re.M)
            if not m or m.group(1) not in EP_FSH_TYPES:
                continue
            checked_fsh += 1
            rules = '\n'.join(l for l in block.splitlines() if l.startswith('*') and 'insert ' not in l)
            h = hits(rules)
            if h:
                name = block.split('\n', 1)[0].replace('Instance:', '').strip()
                problems.append(f'{os.path.relpath(f, ROOT)} Instance {name}: {", ".join(h)}')

    checked_payloads = 0
    payloads = (glob.glob(os.path.join(ROOT, 'input', 'examples', '*.json')) +
                glob.glob(os.path.join(ROOT, 'input', 'examples', '*.xml')) +
                glob.glob(os.path.join(ROOT, 'input', 'postman', '*.json')) +
                glob.glob(os.path.join(ROOT, 'tests', '**', 'fixtures', '**', '*.*'), recursive=True))
    for f in sorted(payloads):
        text = open(f, encoding='utf-8', errors='replace').read()
        is_ep = ('MedicationRequest' in text or 'MedicationDispense' in text or
                 'eprescription' in text.lower() or 'edispensation' in text.lower())
        is_ps_only = any(m in text for m in PS_MARKERS) and 'MedicationRequest' not in text and \
            'MedicationDispense' not in text and 'ePrescription' not in text
        if not is_ep or is_ps_only:
            continue
        checked_payloads += 1
        if f.endswith('.json'):
            data = strip_narrative(json.loads(text))
            h = hits(json.dumps(data))
        else:
            # CDA: ignore comments and <text> narrative blocks
            body = re.sub(r'<!--.*?-->', '', text, flags=re.S)
            body = re.sub(r'<text>.*?</text>', '', body, flags=re.S)
            h = hits(body)
        if h:
            problems.append(f'{os.path.relpath(f, ROOT)}: {", ".join(h)}')

    print(f'checked {checked_generated} generated resources, {checked_fsh} FSH instances, {checked_payloads} payloads')
    if problems:
        print('FAIL: ePrescription/eDispensation content carries demographics outside the HIQA EP dataset (ADR-002):')
        for p in problems:
            print('  ' + p)
        return 1
    if checked_generated == 0:
        print('FAIL: no generated ePrescription resources found; run `sushi .` first')
        return 1
    print('OK: no ethnicity, maiden name, nationality, citizenship, religion or marital status in EP/ED content')
    return 0


if __name__ == '__main__':
    sys.exit(main())
