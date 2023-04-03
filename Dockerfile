FROM debian:buster

LABEL org.opencontainers.image.source="https://github.com/Mr-Leonerrr/labeler-actions"


RUN echo 'deb  http://deb.debian.org/debian  buster contrib non-free' >> /etc/apt/sources.list
RUN echo 'deb-src  http://deb.debian.org/debian  buster contrib non-free' >> /etc/apt/sources.list

RUN apt-get -y update \
    && apt-get -y install \
    apt-transport-https \
    ca-certificates \
    wget

RUN apt-get -yq install \
    python-pip\
    gcc\
    python-dev

RUN apt-get install -f libgd3 -y

RUN apk add --no-cache jq curl

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY /scripts/label-pull-request.sh /label-pull-request.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/label-pull-request.sh"]
