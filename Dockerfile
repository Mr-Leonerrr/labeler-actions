FROM debian:buster

LABEL org.opencontainers.image.source="https://github.com/Mr-Leonerrr/labeler-actions"

RUN echo 'deb  http://deb.debian.org/debian  buster contrib non-free' >> /etc/apt/sources.list
RUN echo 'deb-src  http://deb.debian.org/debian  buster contrib non-free' >> /etc/apt/sources.list

RUN apt-get -y update \
    && apt-get -y install \
    apt-transport-https \
    ca-certificates \
    wget

RUN apt-get -y update \
    && apt-get -y install \
    git \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/doc \
    /usr/share/doc-base

FROM alpine:3.13

RUN apk add --no-cache jq curl && apk update && apk upgrade && apk add --update bash

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY scripts /opt/scripts
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
