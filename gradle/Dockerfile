FROM esvm-builder-base

# install gradle
RUN \
  set -e; \
  curl -sLo gradle.zip https://services.gradle.org/distributions/gradle-3.3-bin.zip; \
  unzip -q gradle.zip; \
  rm gradle.zip; \
  ln -s "${pwd}/gradle-3.3/bin/gradle" /usr/bin/gradle;

CMD ["node", "build.js", "gradle"]