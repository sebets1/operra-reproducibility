FROM rocker/verse:4.5.0

RUN install2.r ggplot2 dplyr kableExtra

RUN apt-get update && apt-get install -y \
    python3-pip \
    git \
    default-jdk-headless \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt && \
    pip3 install --no-cache-dir --break-system-packages polars snakemake && \
    curl -s https://get.nextflow.io | bash && mv nextflow /usr/local/bin/

EXPOSE 8787
ENV USER=rstudio
CMD ["/init"]
