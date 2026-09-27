"""Fail if an IG page links to an artefact page (e.g. StructureDefinition-x.html) that the build will not produce.

Artefacts come from fsh-generated/resources (run `sushi .` first) and input/examples/*.json.
Run: python scripts/qa/check_page_links.py
"""
import glob
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
# Pages the IG Publisher generates itself
PUBLISHER_PAGES = {'artifacts', 'toc', 'qa', 'index', 'downloads', 'profiles', 'extensions', 'terminology'}


def main():
    targets = {os.path.basename(f)[:-5] for f in glob.glob(os.path.join(ROOT, 'fsh-generated', 'resources', '*.json'))}
    for f in glob.glob(os.path.join(ROOT, 'input', 'examples', '*.json')):
        r = json.load(open(f, encoding='utf-8'))
        targets.add(f"{r['resourceType']}-{r['id']}")
    targets |= {os.path.basename(f)[:-3] for f in glob.glob(os.path.join(ROOT, 'input', 'pagecontent', '*.md'))}
    targets |= PUBLISHER_PAGES
    broken = []
    for f in sorted(glob.glob(os.path.join(ROOT, 'input', 'pagecontent', '*.md'))):
        for m in re.finditer(r'\]\(([A-Za-z][A-Za-z0-9._-]*)\.html(?:#[^)]*)?\)', open(f, encoding='utf-8').read()):
            if m.group(1) not in targets:
                broken.append(f'{os.path.basename(f)}: {m.group(1)}.html')
    for b in broken:
        print('BROKEN LINK', b)
    print(f'{len(broken)} broken artefact links')
    return 1 if broken else 0


if __name__ == '__main__':
    sys.exit(main())
