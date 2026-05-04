# Nextflow dev container for the Module 3 demo.
#
# Build from inside this folder:
#   docker build -f Dockerfile.nextflow -t operra-nextflow-demo .
#
# Or use the provided docker-compose.nextflow.yaml.

ARG NEXTFLOW_TAG=26.04.0
FROM nextflow/nextflow:${NEXTFLOW_TAG}

# Used by Docker BuildKit; default for non-buildkit builds.
ARG TARGETARCH=amd64

WORKDIR /workspace

# Install minimal runtime dependencies needed by this workshop demo.
# We intentionally use micromamba (conda-forge) for R + Python + Quarto because
# the base image (Amazon Linux) may not provide R packages out of the box.
RUN yum install -y \
      tar \
      bzip2 \
      gzip \
      ca-certificates \
      git \
    && yum clean all \
    && rm -rf /var/cache/yum

ENV MAMBA_ROOT_PREFIX=/opt/micromamba

RUN set -euo pipefail; \
    case "${TARGETARCH}" in \
      amd64) mm_arch="linux-64" ;; \
      arm64) mm_arch="linux-aarch64" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}" >&2; exit 2 ;; \
    esac; \
    mkdir -p /opt/bin; \
    curl -Ls "https://micro.mamba.pm/api/micromamba/${mm_arch}/latest" | tar -xvj -C /opt/bin bin/micromamba; \
    ln -sf /opt/bin/bin/micromamba /usr/local/bin/micromamba; \
    micromamba --version; \
    micromamba create -y -n demo -c conda-forge \
      python \
      r-base; \
    micromamba clean -a -y

ENV PATH=/opt/micromamba/envs/demo/bin:$PATH

# Install Quarto from the official distribution instead of conda-forge.
# The conda-forge package has recently shipped without the embedded Deno runtime,
# which Quarto expects under `bin/tools/<arch>/deno` for commands like
# `quarto install tinytex`.
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

# Needed for Quarto PDF output. See: `quarto install --help` (`--no-prompt`).
RUN quarto install tinytex --no-prompt
