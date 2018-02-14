#!/usr/bin/env bash

set -e

if [ -d ./target ]; then
  echo " - clearing old build output"
  rm -rf ./target
fi

echo " - building master in docker"
./build-docker.sh master

cd ./target

echo " - validating esCommit in master.json"
esCommit="$(cat master.json | jq -r .esCommit)"
if [[ "$esCommit" =~ ^[0-9a-fA-F]{40}$ ]]; then
  echo " - ✅"
else
  echo "🚫 esCommit in master.json should be a 40 character hex, got '$esCommit'"
  exit 1
fi

echo " - starting es in the background"
tar -xzf master.tar.gz
cd "$(ls -u | head -1)"
./bin/elasticsearch --daemonize -p es.pid

# stop es when the script exits
function stopEs {
  kill "$(cat es.pid)"
}
trap stopEs EXIT

sleep 10
echo " - attempting to read es version.build_hash"
buildHash="$(curl http://localhost:9200 -s | jq -r .version.build_hash)"
if [[ $esCommit == $buildHash* ]]; then
  echo "✅"
else
  echo "🚫 build hash in info output should be the beginning of '$esCommit', got '$buildHash'"
  exit 1
fi
