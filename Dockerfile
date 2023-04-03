LABEL org.opencontainers.image.source="https://github.com/Mr-Leonerrr/labeler-actions"

# Container image that runs your code
FROM alpine:3.13

RUN apk add --no-cache jq curl

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY /scripts/label-pull-request.sh /label-pull-request.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/label-pull-request.sh"]
