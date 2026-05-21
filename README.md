# SwissRN Workshop on Computational Reproducibility

Part of the OPeR-RA workshop series.

The website for this workshop is: <https://crsuzh.pages.uzh.ch/operra-reproducibility>

## Option 1: Open in GitHub Codespaces

- Fork this repository to your account: <https://github.com/a1eksb/operra-reproducibility>

- Create a new codespace: <https://github.com/codespaces/new>

- Select the forked repository
- Select `Dev container configuration` as "Operra - RStudio (project-wide)"
- Create codespace (this may take several minutes)
- Navigate to `Ports`and open the provided URL in a new tab

## Option 2: Running Locally via Docker

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed

### Option A — Docker Compose (recommended)

Clone the repository, then build the image locally and mount the project directory:

```bash
docker compose build pyverse --no-cache
docker compose up -d
```

Open RStudio Server at [http://localhost:8787](http://localhost:8787) — no login required.

To stop:

```bash
docker compose down
```

### Option B — Build and run manually

Build the image locally:

```bash
docker build -t pyverse .
```

Run with the project directory mounted:

```bash
docker run --rm -d \
  -p 127.0.0.1:8787:8787 \
  -e DISABLE_AUTH=true \
  -e USER=rstudio \
  -v "$(pwd)":/home/rstudio/project \
  pyverse
```

Open RStudio Server at [http://localhost:8787](http://localhost:8787) — no login required.

> **Note:** RStudio is bound to `127.0.0.1` only, so it is not accessible from other machines on your network.

## Citation

Cite this workshop as: 

A BibTeX entry is given by: