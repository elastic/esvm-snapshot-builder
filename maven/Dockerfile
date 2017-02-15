FROM esvm-builder-base

# install maven
ENV MVN_URL=http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN \
  set -e; \
  mkdir /maven; \
  curl "$MVN_URL" | tar zx --strip-components=1 -C /maven; \
  ln -s "/maven/bin/mvn" /usr/bin/mvn;

CMD ["/with-profile.sh", "node", "build.js", "maven"]