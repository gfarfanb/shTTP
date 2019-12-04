FROM ubuntu:xenial

WORKDIR /usr/src/shTTP

RUN apt-get update
RUN apt-get install jq -y
RUN apt-get install curl -y
RUN apt-get install shellcheck -y
RUN apt-get install nginx -y
