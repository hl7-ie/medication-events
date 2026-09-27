# syntax=docker/dockerfile:1
# IE Medication Events: local build and test toolchain, and a static site image.
#
# Targets:
#   toolchain  SUSHI, IG Publisher, FHIR Validator, Jekyll, Python, Node: mount the repository at /workspace
#   ci         toolchain + a copy of the repository and the test dependencies (self-contained; used by the k8s Job)
#   site       the published IG with canonical redirects, served by unprivileged nginx on port 8080
#
#   docker build --target toolchain -t ie-mpd-toolchain .
#   docker run --rm -v "$PWD:/workspace" ie-mpd-toolchain test
#   docker build --target site -t ie-mpd-site . && docker run --rm -p 8080:8080 ie-mpd-site
#
# Tool versions match .github/workflows/*.yml; the jars are checked against their SHA-256.

# ── toolchain ───────────────────────────────────────────────────────────────
FROM node:26-bookworm-slim AS toolchain

ARG SUSHI_VERSION=3.18.0
ARG PUBLISHER_VERSION=2.3.4
ARG PUBLISHER_SHA256=970922c12eb583bfb4cb6121584b922a236d5904e36413e3545d2fbc248f8e2b
ARG VALIDATOR_VERSION=6.10.4
ARG VALIDATOR_SHA256=1106b9d58f9e363e47bea7c4fc065841e5fc91fe9d062775c3bfdd212bd653cc
ARG JEKYLL_VERSION=4.4.1

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      openjdk-17-jre-headless python3 ruby ruby-dev build-essential curl ca-certificates git \
 && rm -rf /var/lib/apt/lists/*

RUN gem install jekyll -v "${JEKYLL_VERSION}" --no-document \
 && npm install -g "fsh-sushi@${SUSHI_VERSION}" \
 && npm cache clean --force

RUN mkdir -p /opt/fhir \
 && curl -fsSL -o /opt/fhir/publisher.jar \
      "https://github.com/HL7/fhir-ig-publisher/releases/download/${PUBLISHER_VERSION}/publisher.jar" \
 && echo "${PUBLISHER_SHA256}  /opt/fhir/publisher.jar" | sha256sum -c - \
 && curl -fsSL -o /opt/fhir/validator_cli.jar \
      "https://github.com/hapifhir/org.hl7.fhir.core/releases/download/${VALIDATOR_VERSION}/validator_cli.jar" \
 && echo "${VALIDATOR_SHA256}  /opt/fhir/validator_cli.jar" | sha256sum -c - \
 && chmod 0444 /opt/fhir/*.jar

ENV PUBLISHER_JAR=/opt/fhir/publisher.jar \
    VALIDATOR_JAR=/opt/fhir/validator_cli.jar \
    VALIDATOR_HEAP=3g \
    PUBLISHER_HEAP=4g \
    PYTHON=python3

# The node image's unprivileged user (uid 1000); the FHIR package cache lives in /home/node/.fhir
# (tests/node_modules exists so that a named volume mounted there is created owned by node)
RUN mkdir -p /workspace/tests/node_modules /home/node/.fhir && chown -R node:node /workspace /home/node/.fhir
USER node
WORKDIR /workspace
ENTRYPOINT ["bash", "scripts/local/run-gates.sh"]
CMD ["test"]

# ── ci: self-contained copy of the repository ───────────────────────────────
FROM toolchain AS ci
COPY --chown=node:node tests/package.json tests/package-lock.json tests/
RUN cd tests && npm ci --no-audit --no-fund
COPY --chown=node:node . .

# ── site-build: SUSHI + IG Publisher + canonical redirects ─────────────────
FROM ci AS site-build
RUN bash scripts/local/run-gates.sh publish

# ── site: static IG ─────────────────────────────────────────────────────────
FROM nginxinc/nginx-unprivileged:1.27-alpine AS site
COPY --from=site-build /workspace/site /usr/share/nginx/html
EXPOSE 8080
