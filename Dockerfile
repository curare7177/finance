FROM r-base:3.6.3

ARG GIT_COMMIT_ID="git_commit_id"
ENV GIT_COMMIT_ID ${GIT_COMMIT_ID}

WORKDIR /opt/r_report

COPY ./packrat/ /opt/r_report/packrat/

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    libcurl4-gnutls-dev \
    libssl-dev \
    libsasl2-dev \
    libmariadbclient-dev \
    libxml2-dev \
    default-jdk \
  && install.r packrat \
  && R -e 'library(packrat);packrat::restore()' \
  && R CMD javareconf \
  && apt-get autoremove -y \
  && apt-get clean autoclean \
  && rm -rf /var/lib/{apt,dpkg} \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

COPY configs configs
COPY sys sys
COPY data data
COPY src src
COPY logs logs
COPY main.R .Rprofile ./

###  Python 
COPY requirement.txt requirement.txt
RUN apt-get update \
    && apt-get -y install python3 \
    && apt-get install -y libpython3-dev \
    && apt-get -y install python3-pip
RUN pip3 install --no-cache-dir -r requirement.txt

# CMD ["/bin/bash"]
ENTRYPOINT ["Rscript", "./main.R"]

CMD ["daily"]
