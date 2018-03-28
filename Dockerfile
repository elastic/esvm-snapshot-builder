FROM ubuntu:xenial

RUN \
  set -e; \
  apt-get update; \
  apt-get upgrade -y; \
  apt-get install -y git curl wget;

# install java
# direct download of recent 9.0.4 to avoid https://bugs.java.com/view_bug.do?bug_id=8189357
RUN wget -qO- https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz | tar xz -C /opt/
ENV FORCE_JAVA_INSTALL true
ENV JAVA_HOME /opt/jdk-9.0.4
ENV PATH /root/jdk-9.0.4/bin/:$PATH

WORKDIR /workdir
COPY /build.sh /workdir/build.sh

ENTRYPOINT ["./build.sh"]
