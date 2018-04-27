FROM oraclelinux

MAINTAINER Dixith dixithbura@gmail.com

# Basic packages
RUN yum update -y
RUN rpm -Uvh http://del-mirrors.extreme-ix.org/epel//epel-release-latest-7.noarch.rpm \
 && yum -y install erlang passwd sudo git curl vim wget openssl openssh openssh-server openssh-clients jq

# Create user
RUN useradd sensu \
 && echo "sensu" | passwd sensu --stdin \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config \
 && echo "sensu ALL=(ALL) ALL" >> /etc/sudoers.d/sensu
 
 COPY sensu.repo /etc/yum.repos.d/
 RUN yum install -y sensu uchiwa

RUN cd /opt/sensu/embedded/bin \
 && sensu-install -p cpu-checks  
 && sensu-install -p disk-checks \
 && sensu-install -p memory-checks \
 && sensu-install -p nginx \
 && sensu-install -p process-checks \  
 && sensu-install -p load-checks \  
 && sensu-install -p vmstats \  
 && sensu-install -p mailer 

    rm -rvf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/*

ENV PATH ${PATH}:/opt/sensu/bin:/opt/sensu/embedded/bin:/opt/uchiwa/bin

COPY check_k8s.json /etc/sensu/conf.d
COPY uchiwa.json /etc/sensu
COPY entrypoint.sh /

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
