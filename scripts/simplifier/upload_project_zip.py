"""Upload this IG's conformance resources and examples to a Simplifier.net project (Project ZIP API).

Simplifier API (https://github.com/FirelyTeam/firely-docs-simplifier/blob/main/adding_content/api.rst):
    POST https://api.simplifier.net/token          {"Email": ..., "Password": ...}  -> {"token": ..., "refreshToken": ...}
    PUT  https://api.simplifier.net/<project>/zip  Authorization: Bearer <token>     (update the project in zipped form)

This **updates the project's files only**. A Simplifier *package release* cannot be created through the API ("It is
not possible to create a package using the API"), so releasing `nostalgic-ie.fhir.medication-events` stays a manual,
deliberate step in Simplifier: package versions are permanent.

Needs `sushi .` and `python scripts/simplifier/build_bundle.py` first (it reads build/simplifier/resources/).
Credentials come from the environment and are never printed:
    SIMPLIFIER_EMAIL, SIMPLIFIER_PASSWORD

Run:
    python scripts/simplifier/upload_project_zip.py <project-url-key>            # dry run: build the zip, list it
    python scripts/simplifier/upload_project_zip.py <project-url-key> --upload   # upload
"""
import io
import json
import os
import re
import sys
import urllib.error
import urllib.request
import zipfile

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
RESOURCES = os.path.join(ROOT, 'build', 'simplifier', 'resources')
OUT_ZIP = os.path.join(ROOT, 'build', 'simplifier-project.zip')
API = 'https://api.simplifier.net'
URL_KEY = re.compile(r'^[A-Za-z0-9][A-Za-z0-9\-_.]{0,99}$')


def build_zip():
    """resources/conformance/* and resources/examples/* -> a zip with the same folders."""
    if not os.path.isdir(RESOURCES):
        sys.exit('build/simplifier/resources not found: run `sushi .` and scripts/simplifier/build_bundle.py first')
    buf = io.BytesIO()
    names = []
    with zipfile.ZipFile(buf, 'w', zipfile.ZIP_DEFLATED) as z:
        for folder, _, files in os.walk(RESOURCES):
            for fn in sorted(files):
                if fn.endswith('.json'):
                    path = os.path.join(folder, fn)
                    arc = os.path.relpath(path, RESOURCES).replace(os.sep, '/')
                    z.write(path, arc)
                    names.append(arc)
    data = buf.getvalue()
    os.makedirs(os.path.dirname(OUT_ZIP), exist_ok=True)
    open(OUT_ZIP, 'wb').write(data)
    return data, names


def request(method, url, body=None, headers=None):
    req = urllib.request.Request(url, data=body, method=method, headers=headers or {})
    try:
        with urllib.request.urlopen(req, timeout=300) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()


def token():
    email, password = os.environ.get('SIMPLIFIER_EMAIL'), os.environ.get('SIMPLIFIER_PASSWORD')
    if not email or not password:
        sys.exit('SIMPLIFIER_EMAIL and SIMPLIFIER_PASSWORD must be set to upload')
    status, body = request('POST', f'{API}/token', json.dumps({'Email': email, 'Password': password}).encode(),
                           {'Content-Type': 'application/json'})
    if status != 200:
        sys.exit(f'Simplifier login failed (HTTP {status})')   # the body is not printed: it may echo account details
    tok = json.loads(body).get('token')
    if not tok:
        sys.exit('Simplifier login returned no token')
    if os.environ.get('GITHUB_ACTIONS') == 'true':
        print(f'::add-mask::{tok}')
    return tok


def main(argv):
    args = [a for a in argv if not a.startswith('--')]
    if len(args) != 1 or not URL_KEY.match(args[0]):
        sys.exit('usage: upload_project_zip.py <project-url-key> [--upload]')
    project = args[0]
    data, names = build_zip()
    n_conf = sum(1 for n in names if n.startswith('conformance/'))
    print(f'{os.path.relpath(OUT_ZIP, ROOT)}: {len(names)} resources ({n_conf} conformance, '
          f'{len(names) - n_conf} examples), {len(data) // 1024} KiB')
    if '--upload' not in argv:
        print(f'dry run: not uploaded. Add --upload to PUT it to {API}/{project}/zip')
        return 0
    status, body = request('PUT', f'{API}/{project}/zip', data,
                           {'Authorization': f'Bearer {token()}', 'Content-Type': 'application/zip'})
    if status not in (200, 201, 204):
        print(f'upload failed: HTTP {status}')
        print(body[:2000].decode('utf-8', 'replace'))
        return 1
    print(f'uploaded to https://simplifier.net/{project} (HTTP {status}). '
          f'No package was released: create the release in Simplifier (Releases -> Create).')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
