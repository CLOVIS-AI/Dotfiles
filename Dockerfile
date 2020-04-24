FROM archlinux:latest

RUN pacman -Sy --noconfirm git openssh curl zip unzip which jre-openjdk jdk-openjdk

SHELL ["/bin/bash", "-c"]

# Copying this repo to the Docker image.
COPY . /root/config

# Add the scripts to the PATH.
ENV PATH /root/config/scripts:$PATH

# Install kscript via SDKMAN
RUN ensure_kscript 'println("kscript runs!")'
