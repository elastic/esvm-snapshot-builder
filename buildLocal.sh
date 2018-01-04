#!/usr/bin/env bash

## - must be run from the root of the repo
## - runs build.sh in a docker container, placing built artifacts in ./target

docker build --rm -t esvm-snapshot-builder-jenkins-test .

docker run \
  --interactive \
  --tty \
  -e "ES_BRANCH=${1:-master}" \
  -e "ES_REMOTE=https://github.com/elastic/elasticsearch.git" \
  --mount "type=bind,source=$(pwd)/target,destination=/workdir/target" \
  esvm-snapshot-builder-jenkins-test
