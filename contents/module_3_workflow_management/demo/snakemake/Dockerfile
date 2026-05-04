# Snakemake dev container for the Module 3 demo.
#
# Build from inside this folder:
#   docker build -t operra-snakemake-demo .
#
# Or use the provided docker-compose.yaml.

ARG SNAKEMAKE_TAG=v9.20.0
FROM snakemake/snakemake:${SNAKEMAKE_TAG}

# Used by Docker BuildKit; default for non-buildkit builds.
ARG TARGETARCH=amd64

WORKDIR /workspace

# The base image provides Python and Snakemake. Add R from conda-forge.
RUN micromamba install -y -n base -c conda-forge \
      git \
      r-base \
    && micromamba clean -a -y

# Install Quarto from the official distribution instead of conda-forge.
# The conda-forge package has recently shipped without the embedded Deno runtime,
# which Quarto expects under `bin/tools/<arch>/deno`.
ARG QUARTO_VERSION=1.8.26
RUN set -euo pipefail; \
    case "${TARGETARCH}" in \
      amd64) qt_arch="linux-amd64" ;; \
      arm64) qt_arch="linux-arm64" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}" >&2; exit 2 ;; \
    esac; \
    curl -Ls "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-${qt_arch}.tar.gz" \
      | tar -xz -C /opt; \
    ln -sf "/opt/quarto-${QUARTO_VERSION}/bin/quarto" /usr/local/bin/quarto; \
    quarto --version
