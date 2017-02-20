FROM debian:jessie
MAINTAINER moss2k13 <moss2k03@yahoo.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
      # Requires by check-memory-percent
      bc \
      build-essential \
      ca-certificates \
      curl && \
    curl -L 'http://repos.sensuapp.org/apt/pubkey.gpg' | apt-key add - && \
    echo 'deb http://repos.sensuapp.org/apt sensu main' > /etc/apt/sources.list.d/sensu.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      sensu uchiwa && \
    /opt/sensu/embedded/bin/gem install --no-rdoc \
      sensu-plugins-cpu-checks \
      sensu-plugins-disk-checks \
      sensu-plugins-memory-checks:1.0.2\
      sensu-plugins-network-checks \
      sensu-plugins-kubernetes \
      sensu-plugins-mailer && \
    apt-get purge -y \
      build-essential \
      ca-certificates \
      curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rvf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/*

ENV PATH ${PATH}:/opt/sensu/bin:/opt/sensu/embedded/bin:/opt/uchiwa/bin

COPY check_k8s.json /etc/sensu/conf.d
COPY uchiwa.json /etc/sensu
COPY entrypoint.sh /

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
