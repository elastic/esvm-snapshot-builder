#!/usr/bin/env bash

set -e

source .env

function create_docker_machine {
 docker-machine create \
   --driver amazonec2 \
   --amazonec2-access-key=$AWS_ACCESS_KEY_ID \
   --amazonec2-secret-key=$AWS_SECRET_ACCESS_KEY \
   --amazonec2-vpc-id=$AWS_VPC_ID \
   --amazonec2-subnet-id=$AWS_SUBNET_ID \
   --amazonec2-region=$AWS_DEFAULT_REGION \
   --amazonec2-instance-type=c4.2xlarge \
   --amazonec2-request-spot-instance=true \
   --amazonec2-spot-price=4.0 \
   --amazonec2-root-size=40 \
   esvm-snapshot-builder
}

function remove_docker_machine {
 docker-machine rm -f -y esvm-snapshot-builder
}

create_docker_machine
trap remove_docker_machine EXIT
eval "$(docker-machine env --shell bash esvm-snapshot-builder)"
./run.sh
