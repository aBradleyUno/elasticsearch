FROM centos:latest

LABEL maintainer=Elastic Docker Team <docker@elastic.co>

ENV ELASTIC_CONTAINER=true
ENV PATH=/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk

RUN yum update -y &&
    yum install -y nc java-1.8.0-openjdk-headless unzip wget which &&
    yum clean all

RUN groupadd -g 1000 elasticsearch &&
    adduser -u 1000 -g 1000 -G 0 -d /usr/share/elasticsearch elasticsearch &&
    chmod 0775 /usr/share/elasticsearch &&
    chgrp 0 /usr/share/elasticsearch

WORKDIR /usr/share/elasticsearch

COPY --chown=1000:0 ./elasticsearch /usr/share/elasticsearch
COPY --chown=1000:0 ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chgrp 0 /usr/local/bin/docker-entrypoint.sh &&
    chmod g=u /etc/passwd &&
    chmod 0775 /usr/local/bin/docker-entrypoint.sh

EXPOSE 9200 9300

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]"
CMD ["eswrapper"]
