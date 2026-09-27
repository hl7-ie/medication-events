#!/usr/bin/env bash
# Run the CI gates locally, in the same order as .github/workflows/pr-validation.yml.
# Used by the Docker image (entrypoint) and docker-compose; also runs on any machine with the tools installed.
#
#   run-gates.sh test       SUSHI, BDD, HIQA traceability/mapping, data-minimisation guard, open issues, page links,
#                           Simplifier bundle (no network needed beyond the FHIR package registry)
#   run-gates.sh validate   FHIR Validator on every example (--tx: tx.fhir.org) and the whole-IG QA baseline
#   run-gates.sh codes      verify every explicit code on tx.fhir.org
#   run-gates.sh publish    IG Publisher -> output/, then canonical redirects -> site/
#   run-gates.sh all        test + validate + codes + publish
#   run-gates.sh shell      an interactive shell
#
# Tools (pinned in the Dockerfile): SUSHI 3.18.0, IG Publisher 2.3.4, FHIR Validator 6.10.4, Jekyll 4.4.1.
set -euo pipefail

cd "$(dirname "$0")/../.."
PUBLISHER_JAR="${PUBLISHER_JAR:-input-cache/publisher.jar}"
VALIDATOR_JAR="${VALIDATOR_JAR:-tests/validator/validator_cli.jar}"
# python3 on Linux/macOS; on Windows (Git Bash) python3 may be the Store stub, so fall back to python
if [ -z "${PYTHON:-}" ]; then
  if python3 -c '' >/dev/null 2>&1; then PYTHON=python3; else PYTHON=python; fi
fi

step() { printf '\n==> %s\n' "$*"; }

sushi_run() {
  step "SUSHI"
  sushi . | tee /tmp/sushi.log
  grep -Eq '\b0 Errors\b' /tmp/sushi.log || { echo "SUSHI reported errors"; exit 1; }
}

tests_install() {
  if [ ! -d tests/node_modules/.bin ]; then   # an empty directory is a fresh Docker volume
    step "npm ci (tests)"
    (cd tests && npm ci --no-audit --no-fund)
  fi
}

gate_test() {
  sushi_run
  tests_install
  step "BDD";                                   (cd tests && npm run test:bdd)
  step "HIQA traceability is current";          "$PYTHON" scripts/hiqa/generate_traceability.py --check
  step "HIQA mapping agrees with the profiles"; "$PYTHON" scripts/hiqa/check_mapping_against_snapshots.py
  step "Data-minimisation guard";               "$PYTHON" scripts/qa/check_ep_data_minimisation.py
  step "Open-issues page is in sync";           "$PYTHON" scripts/hiqa/sync_open_issues.py --check
  step "Page links";                            "$PYTHON" scripts/qa/check_page_links.py
  step "Simplifier bundle";                     "$PYTHON" scripts/simplifier/build_bundle.py
  step "Simplifier project zip (dry run)";      "$PYTHON" scripts/simplifier/upload_project_zip.py "${SIMPLIFIER_PROJECT:-nostalgic-ie}"
}

gate_validate() {
  [ -d fsh-generated/resources ] || sushi_run
  tests_install
  [ -f "$VALIDATOR_JAR" ] || { echo "validator jar not found at $VALIDATOR_JAR"; exit 1; }
  step "FHIR Validator: every example (--tx)";  (cd tests && node validator/run-validation.js --tx)
  step "Whole-IG validator QA vs baseline"
  "$PYTHON" scripts/qa/validate_all.py . "$VALIDATOR_JAR" build/qa.json
  "$PYTHON" scripts/qa/qa_gate.py build/qa.json
}

gate_codes() {
  step "Verify codes"
  "$PYTHON" scripts/terminology/verify_codes.py | tee /tmp/verify.log
  grep -Eq ' 0 not found, errored or inactive$' /tmp/verify.log
}

gate_publish() {
  [ -f "$PUBLISHER_JAR" ] || { echo "IG Publisher jar not found at $PUBLISHER_JAR"; exit 1; }
  step "IG Publisher"
  java -Xmx${PUBLISHER_HEAP:-6g} -Dfile.encoding=UTF-8 -jar "$PUBLISHER_JAR" -ig .
  step "Site with canonical redirects -> site/"
  rm -rf site && cp -r output site
  GITHUB_REPOSITORY=hl7-ie/medication-events node scripts/generate-canonical-redirects.mjs site
}

case "${1:-test}" in
  test)     gate_test ;;
  validate) gate_validate ;;
  codes)    gate_codes ;;
  publish)  gate_publish ;;
  all)      gate_test; gate_validate; gate_codes; gate_publish ;;
  shell)    exec bash ;;
  *)        sed -n '2,13p' "$0"; exit 2 ;;
esac
printf '\nOK: %s\n' "${1:-test}"
