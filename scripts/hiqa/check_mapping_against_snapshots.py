"""Cross-check hand-assigned mapping statuses against the SUSHI-generated snapshots.

For each mapping row with a path, look up the element in the target profile's snapshot
(fsh-generated/resources, including inherited constraints) and derive the status that the
conformance convention implies:
  Mandatory -> Aligned iff min >= 1 and mustSupport
  Required  -> Aligned iff mustSupport
  Optional  -> Aligned if the element exists
Reports rows where the hand status disagrees, or where the path does not resolve.
Run `sushi .` first. Used in Phase 3 and as a helper for the Phase 8 traceability test.
"""
import csv
import glob
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))


PACKAGES = ['hl7.fhir.r4.core#4.0.1', 'hl7.fhir.eu.base#2.0.0', 'hl7.fhir.eu.mpd#1.0.0',
            'ihe.pharm.mpd.r4#1.0.0-comment-2']


def load_snapshots():
    """SUSHI emits differentials only, so build an effective element view per IE profile by
    walking baseDefinition through the differentials (most-derived wins) down to a core snapshot."""
    by_url, names = {}, {}
    cache = os.path.join(os.path.expanduser('~'), '.fhir', 'packages')
    files = glob.glob(os.path.join(ROOT, 'fsh-generated', 'resources', 'StructureDefinition-*.json'))
    missing = [p for p in PACKAGES if not os.path.isdir(os.path.join(cache, p, 'package'))]
    if missing:
        # Without the parent packages, inherited cardinality/MustSupport cannot be seen and every inherited
        # constraint would look like an over-claim. Fail loudly instead (run `sushi .` to fill the cache).
        sys.exit(f'FHIR packages missing from {cache}: {", ".join(missing)}. Run `sushi .` first.')
    for p in PACKAGES:
        files += glob.glob(os.path.join(cache, p, 'package', 'StructureDefinition-*.json'))
    for f in files:
        sd = json.load(open(f, encoding='utf-8'))
        by_url.setdefault(sd['url'], sd)
        if 'fsh-generated' in f:
            names[sd['name']] = sd['url']

    def effective(url):
        chain, u = [], url
        while u and u in by_url:
            chain.append(by_url[u])
            if by_url[u].get('derivation') != 'constraint':
                break
            u = by_url[u].get('baseDefinition')
        view = {}
        for sd in reversed(chain):  # base first, then overlay each differential
            src = sd['snapshot']['element'] if (sd is chain[-1] and 'snapshot' in sd) else sd.get('differential', {}).get('element', [])
            for e in src:
                cur = view.setdefault(e['id'], {})
                for k in ('min', 'max', 'mustSupport'):
                    if k in e:
                        cur[k] = e[k]
        return view
    return {n: effective(u) for n, u in names.items()}


def resolve(elements, path):
    """Map a mapping-CSV path (e.g. Patient.identifier:IHI.value) to a snapshot element."""
    if path in elements:
        return elements[path]
    alt = path.replace('[x]', '')
    for k, e in elements.items():
        if k.replace('[x]', '') == alt:
            return e
    return None


def derived_status(conf, card, el):
    # Cardinality max is not compared: HIQA repetition usually sits one level up (e.g. one
    # AllergyIntolerance per allergy), so a max mismatch is a hand-review item, not a rule.
    ms = bool(el.get('mustSupport'))
    if conf == 'Mandatory':
        return 'Aligned' if (el.get('min', 0) >= 1 and ms) else 'Partial'
    if conf == 'Required':
        return 'Aligned' if ms else 'Partial'
    return 'Aligned'


def main():
    snaps = load_snapshots()
    diffs, unresolved = [], []
    for key in ['ep']:
        facts = {r['id']: r for r in csv.DictReader(open(os.path.join(ROOT, f'docs/sources/hiqa-2026/{key}-elements.csv'), encoding='utf-8'))}
        for m in csv.DictReader(open(os.path.join(ROOT, f'docs/hiqa-2026/mapping/{key}-mapping.csv'), encoding='utf-8')):
            if not m['path'] or m['hiqa_id'].startswith('NA-') or m['hiqa_id'] not in facts:
                continue
            if '.' not in m['path'] or m['path'].endswith('section.entry'):
                continue  # resource root / generic entry: min is not meaningful here
            els = snaps.get(m['profile'])
            el = resolve(els, m['path']) if els else None
            if el is None:
                unresolved.append((key.upper(), m['hiqa_id'], m['profile'], m['path']))
                continue
            conf = facts[m['hiqa_id']]['conformance']
            d = derived_status(conf, facts[m['hiqa_id']]['cardinality'], el)
            if d != m['status']:
                diffs.append((key.upper(), m['hiqa_id'], conf, m['profile'], m['path'],
                              f"min={el.get('min')} max={el.get('max')} MS={bool(el.get('mustSupport'))}",
                              f'hand={m["status"]} derived={d}', m['notes']))
    # Over-claims (hand says Aligned, structure says otherwise) are errors. Hand "Partial" where the
    # structure looks fine is allowed only with a note giving the semantic reason.
    # "Mandatory within the ... cluster" rows are enforced when the cluster is present (ADR-001).
    # "enforced by invariant <key>" rows are conditionally required by a named invariant; the Phase 8
    # traceability test checks that the named invariant exists on the profile.
    over = [d for d in diffs if 'hand=Aligned' in d[6]
            and 'Mandatory within' not in d[7] and 'enforced by invariant' not in d[7]]
    unexplained = [d for d in diffs if 'hand=Partial' in d[6] and not d[7]]
    print(f'{len(over)} over-claims (hand Aligned, structure Partial)')
    for d in over:
        print('  ERROR ' + ' | '.join(d))
    print(f'{len(unexplained)} unexplained semantic partials (hand Partial with no note)')
    for d in unexplained:
        print('  ERROR ' + ' | '.join(d))
    print(f'{len(diffs) - len(over) - len(unexplained)} semantic partials with a reason (OK)')
    print(f'{len(unresolved)} unresolved paths (semantic or slice-internal; checked by hand)')
    if '--verbose' in sys.argv:
        for u in unresolved:
            print('  ' + ' | '.join(u))
    return 1 if (over or unexplained) else 0


if __name__ == '__main__':
    sys.exit(main())
