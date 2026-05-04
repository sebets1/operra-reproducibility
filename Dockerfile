FROM rocker/verse:4.5.0

RUN install2.r ggplot2 dplyr kableExtra

COPY requirements.txt . 

RUN apt-get update && apt-get install -y python3-pip git && \
    pip3 install --no-cache-dir --break-system-packages -r requirements.txt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 8787

ENV USER=rstudio
ENV PASSWORD=rstudio

# Start RStudio Server
CMD ["/init"]
