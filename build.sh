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

if [ ! -x "$dir/gradlew" ] || [ ! -x "$dir/build.sh" ]; then
  echo "esvm-snapshot-builder/build.sh must be run from within the repo"
fi


echo " -- cloning elasticsearch $ES_BRANCH to $repo"
git clone "$ES_REMOTE" --branch "$ES_BRANCH" --depth 1 "$repo"

## enter elasticsearch repo
cd "$repo"

echo " -- reading git info from elasticsearch repo"
esCommit="$(git rev-parse --verify HEAD)"
esCommitTime="$(git show -s --format=%at "$esCommit")"

echo " -- building elasticsearch"
"$dir/gradlew" clean :distribution:tar:assemble :distribution:zip:assemble --stacktrace

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
find "$repo/distribution/zip" -name '*elasticsearch*.zip' -execdir cp '{}' "$target/$ES_BRANCH.zip" ';'
find "$repo/distribution/tar" -name '*.tar.gz' -execdir cp '{}' "$target/$ES_BRANCH.tar.gz" ';'
