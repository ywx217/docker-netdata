FROM ywx217/docker-supervisor:latest
MAINTAINER Wenxuan Yang "ywx217@gmail.com"

# get and build netdata
ADD netdata /netdata
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        autoconf \
        autoconf-archive \
        autogen \
        automake \
        curl \
        gcc \
        jq \
        libmnl-dev \
        lm-sensors \
        make \
        netcat-openbsd \
        nodejs \
        pkg-config \
        python \
        python-mysqldb \
        python-yaml \
        uuid-dev \
        zlib1g-dev \
    && cd /netdata \
    && ./netdata-installer.sh --dont-wait --dont-start-it \
    && cd / \
    && rm -rf /netdata \
    && dpkg -P zlib1g-dev uuid-dev libmnl-dev gcc make autoconf autogen automake pkg-config \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -sf /dev/stdout /var/log/netdata/access.log \
    && ln -sf /dev/stdout /var/log/netdata/debug.log \
    && ln -sf /dev/stderr /var/log/netdata/error.log

ENV NETDATA_PORT 19999
EXPOSE $NETDATA_PORT
COPY netdata.conf /etc/supervisor/conf.d/netdata.conf
