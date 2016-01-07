FROM alpine:3.3

MAINTAINER Raymond.Otto@RTL.nl

ENV TZ=Europe/Amsterdam

ENV CONSUL_VER=0.6.0
ENV CONSUL_GUI=0.5.2
ENV DOCKER_VER=1.8.3

RUN apk add --update bash wget curl

RUN mkdir /data
WORKDIR /data

RUN curl -O https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip && \
    unzip consul_${CONSUL_VER}_linux_amd64.zip && \
    mv consul /bin && \
    chmod 755 /bin/consul

RUN curl -O https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VER} && \
    mv docker-${DOCKER_VER} /bin/docker && \
    chmod 755 /bin/docker

RUN wget https://dl.bintray.com/mitchellh/consul/${CONSUL_GUI}_web_ui.zip && \
    unzip ${CONSUL_GUI}_web_ui.zip && \
    mv dist /ui

WORKDIR /
RUN rm -fr /data

ADD ./start /bin/start
ADD ./check-http /bin/check-http
ADD ./check-cmd /bin/check-cmd

ADD ./config /config
ONBUILD ADD ./config /config

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
VOLUME ["/data"]

ENV SHELL /bin/bash

ENTRYPOINT ["/bin/start"]
CMD []
