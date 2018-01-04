FROM openjdk:8-jdk-slim-stretch

RUN \
  set -e; \
  apt-get update; \
  apt-get upgrade -y; \
  apt-get install -y git curl;

WORKDIR /snapshot
COPY /gradle /snapshot/gradle
COPY /build.sh /snapshot/build.sh
COPY /gradlew /snapshot/gradlew

ENTRYPOINT ["./build.sh"]
