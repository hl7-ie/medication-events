"""CI gate: fail if validator QA errors rise above the recorded baseline.

Reads the summary written by scripts/qa/validate_all.py and compares it with scripts/qa/qa-baseline.json.
Lower the baseline whenever errors are fixed, so it only ever ratchets down.
Run: python scripts/qa/qa_gate.py <validate_all output.json>
"""
import json
import os
import sys

BASELINE = os.path.join(os.path.dirname(__file__), 'qa-baseline.json')


def main(path):
    summary = json.load(open(path, encoding='utf-8'))['summary']
    base = json.load(open(BASELINE, encoding='utf-8'))
    print(f"validator QA: {summary['error']} errors (baseline {base['max_errors']}), "
          f"{summary['resources_with_errors']} resources with errors")
    if summary['error'] > base['max_errors']:
        print(f"FAIL: QA errors rose above the baseline. {base['explanation']}")
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1]))
