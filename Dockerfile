FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y install pandoc ruby asciidoctor

RUN mkdir /app
WORKDIR /app
