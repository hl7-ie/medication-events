"""Apply a batch of row updates to docs/hiqa-2026/mapping/{ep,ps}-mapping.csv.

Usage (from Python):
    from update_mapping import apply
    apply('ep', {'1.1.2': ('IEMpdPatientEPrescription', 'Patient.name.given', 'Y', 'Aligned', 'note')})

Rows are keyed by hiqa_id. A new NA-* id is appended. Writes with proper CSV quoting.
"""
import csv
import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
FIELDS = ['hiqa_id', 'profile', 'path', 'ms', 'status', 'notes']


def apply(std, updates):
    path = os.path.join(ROOT, 'docs', 'hiqa-2026', 'mapping', f'{std}-mapping.csv')
    rows = list(csv.DictReader(open(path, encoding='utf-8')))
    index = {r['hiqa_id']: r for r in rows}
    for hid, (profile, p, ms, status, notes) in updates.items():
        row = dict(zip(FIELDS, [hid, profile, p, ms, status, notes]))
        if hid in index:
            index[hid].update(row)
        elif hid.startswith('NA-'):
            rows.append(row)
            index[hid] = row
        else:
            raise KeyError(f'{std} {hid}: unknown HIQA element')
    with open(path, 'w', newline='', encoding='utf-8') as fh:
        w = csv.DictWriter(fh, fieldnames=FIELDS, lineterminator='\n')
        w.writeheader()
        w.writerows(rows)
    return len(updates)
