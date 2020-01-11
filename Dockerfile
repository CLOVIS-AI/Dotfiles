FROM alpine:latest

# Copying this repo to the Docker image.
COPY . /root/config

# Sourcing the environnement variable, to get the correct PATH to be able to call commands.
RUN source ~/config/bashrc