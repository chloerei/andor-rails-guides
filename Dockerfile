FROM ubuntu:16.04

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && \
    apt-get -y install pandoc ruby ruby-dev build-essential zlib1g-dev

RUN gem install asciidoctor nokogiri

RUN mkdir /app
WORKDIR /app
