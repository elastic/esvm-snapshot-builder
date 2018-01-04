FROM openjdk:8-jdk-slim-stretch

RUN \
  set -e; \
  apt-get update; \
  apt-get upgrade -y; \
  apt-get install -y git curl;

WORKDIR /workdir
COPY /build.sh /workdir/build.sh

ENTRYPOINT ["./build.sh"]
