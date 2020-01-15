FROM alpine:latest

RUN apk --no-cache --update add git openssh curl bash coreutils

SHELL ["/bin/bash", "-c"]

# Copying this repo to the Docker image.
COPY . /root/config

# Add the scripts to the PATH.
ENV PATH /root/config/scripts:$PATH
