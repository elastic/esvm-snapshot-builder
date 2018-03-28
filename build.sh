#!/usr/bin/env bash

set -e;

dir="$(pwd)"
repo="$dir/es_repo"
target="$dir/target"

if [ -z "$ES_BRANCH" ]; then
  echo "ES_BRANCH environment variable must be set to run build.sh"
  exit 1
fi

if [ -z "$ES_REMOTE" ]; then
  echo "ES_REMOTE environment variable must be set to run build.sh"
  exit 1
fi

if [ ! -x "$dir/build.sh" ]; then
  echo "esvm-snapshot-builder/build.sh must be run from within the repo"
fi


echo " -- cloning elasticsearch $ES_BRANCH to $repo"
git clone "$ES_REMOTE" --branch "$ES_BRANCH" --depth 1 "$repo"

## enter elasticsearch repo
cd "$repo"

if [ "$FORCE_JAVA_INSTALL" != "true" ] && grep 'JDK 9 is required' CONTRIBUTING.md; then
  export RUNTIME_JAVA_HOME=$HOME/.java/java8
  export JAVA_HOME=$HOME/.java/java9
fi

if [ "$FORCE_JAVA_INSTALL" != "true" ] && grep 'JDK 10 is required' CONTRIBUTING.md; then
  export RUNTIME_JAVA_HOME=$HOME/.java/java8
  export JAVA_HOME=$HOME/.java/openjdk10
fi

echo " -- reading git info from elasticsearch repo"
esCommit="$(git rev-parse --verify HEAD)"
esCommitTime="$(git show -s --format=%at "$esCommit")"

echo " -- building elasticsearch"

esBuildProj=":distribution"
esBuildDir="$repo/distribution"
if [ -d "$repo/distribution/archives" ]; then
  esBuildProj=":distribution:archives"
  esBuildDir="$repo/distribution/archives"
fi

echo "-- running ./gradlew clean \"$esBuildProj:tar:assemble\" \"$esBuildProj:zip:assemble\" --stacktrace"

./gradlew clean "$esBuildProj:tar:assemble" "$esBuildProj:zip:assemble" --stacktrace

## return to working directory
cd "$dir"

echo " -- copying artifacts to $target"
mkdir -p "$target"
echo "{
  \"esRepo\":\"${ES_REMOTE}\",
  \"esBranch\":\"${ES_BRANCH}\",
  \"esCommit\": \"${esCommit}\",
  \"esCommitTime\": ${esCommitTime},
  \"buildTime\": $(date +"%s")
}" >> "$target/$ES_BRANCH.json"

find "$esBuildDir/zip/build" -name '*elasticsearch*.zip' -execdir cp '{}' "$target/$ES_BRANCH.zip" ';'
find "$esBuildDir/tar/build" -name '*.tar.gz' -execdir cp '{}' "$target/$ES_BRANCH.tar.gz" ';'
