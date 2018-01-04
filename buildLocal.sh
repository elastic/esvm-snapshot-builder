#!/usr/bin/env bash

## - takes es branch name as first and only argument
## - must be run from the root of the repo
## - runs build.sh in a docker container, placing built artifacts in ./target

set -e
target="$(pwd)/target"

# rebuild docker image
docker build --rm -t esvm-snapshot-builder-jenkins-test .

# make sure the target directory exists of docker run will complain
mkdir -p "$target"

# run the build script within the image, puts the artifacts into $target
docker run \
  --interactive \
  --tty \
  -e "ES_BRANCH=${1:-master}" \
  -e "ES_REMOTE=https://github.com/elastic/elasticsearch.git" \
  --mount "type=bind,src=${target},target=/workdir/target" \
  esvm-snapshot-builder-jenkins-test
