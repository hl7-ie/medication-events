"""Validator-based QA: validate every SUSHI-generated resource with the FHIR Validator CLI.

Used as the QA gate where the IG Publisher cannot complete (e.g. no Jekyll on the build host).
Runs ONE validator invocation over fsh-generated/resources with every dependency declared in
sushi-config.yaml, and summarises errors / warnings / information per resource.

Usage:  python scripts/qa/validate_all.py <ig-dir> <validator_cli.jar> <out.json>
Output: <out.json> = {"summary": {...}, "resources": {file: {"error": n, "warning": n, "messages": [...]}}}
"""
import json
import os
import re
import subprocess
import sys


def dependencies(ig_dir):
    text = open(os.path.join(ig_dir, 'sushi-config.yaml'), encoding='utf-8').read()
    block = text.split('\ndependencies:', 1)[1].split('\n\n', 1)[0]
    deps, current = [], None
    for line in block.splitlines():
        m = re.match(r'^  ([\w.\-]+):\s*(\S+)?\s*$', line)
        if m:
            current = m.group(1)
            if m.group(2):
                deps.append(f'{current}#{m.group(2)}')
            continue
        m = re.match(r'^    version:\s*(\S+)', line)
        if m and current:
            deps.append(f'{current}#{m.group(1)}')
    # SUSHI pseudo-package (R5 cross-version extensions) is resolved natively by the validator
    return [d for d in deps if not d.startswith('hl7.fhir.extensions.r5#')]


def main(ig_dir, jar, out):
    res_dir = os.path.join(ig_dir, 'fsh-generated', 'resources')
    raw = out + '.raw.json'
    cmd = ['java', '-Xmx6g', '-Dfile.encoding=UTF-8', '-jar', jar, res_dir, '-version', '4.0.1',
           '-ig', res_dir, '-output', raw, '-level', 'warnings', '-display-issues-are-warnings']
    for d in dependencies(ig_dir):
        cmd += ['-ig', d]
    print('deps:', ' '.join(dependencies(ig_dir)))
    proc = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8', errors='replace')
    open(out + '.log', 'w', encoding='utf-8').write(proc.stdout + '\n' + proc.stderr)
    data = json.load(open(raw, encoding='utf-8'))
    outcomes = [e['resource'] for e in data.get('entry', [])] if data.get('resourceType') == 'Bundle' else [data]
    resources, totals = {}, {'error': 0, 'warning': 0, 'information': 0}
    for oo in outcomes:
        fname = next((ext.get('valueString') for ext in oo.get('extension', [])
                      if ext.get('url', '').endswith('operationoutcome-file')), '?')
        fname = os.path.basename(fname)
        rec = resources.setdefault(fname, {'error': 0, 'warning': 0, 'information': 0, 'messages': []})
        for issue in oo.get('issue', []):
            sev = issue.get('severity')
            sev = 'error' if sev == 'fatal' else sev
            if sev in rec:
                rec[sev] += 1
                totals[sev] += 1
                if sev in ('error', 'warning'):
                    loc = (issue.get('expression') or issue.get('location') or [''])[0]
                    rec['messages'].append(f"{sev.upper()} {loc}: {issue.get('details', {}).get('text') or issue.get('diagnostics', '')}")
    summary = dict(totals, resources=len(resources), resources_with_errors=sum(1 for r in resources.values() if r['error']))
    json.dump({'summary': summary, 'resources': resources}, open(out, 'w', encoding='utf-8'), indent=1)
    print(json.dumps(summary))


if __name__ == '__main__':
    main(*sys.argv[1:4])
