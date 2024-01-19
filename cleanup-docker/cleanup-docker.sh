#!/bin/bash

# remove exited containers:
docker ps --filter status=dead --filter status=exited -aq | xargs -r docker rm -v
    
# remove unused images:
docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")

# remove unused volumes:
find '/var/lib/docker/volumes/' -mindepth 1 -maxdepth 1 -type d | grep -vFf <(
  docker ps -aq | xargs docker inspect | jq -r '.[] | .Mounts | .[] | .Name | select(.)'
) | xargs -r rm -fr

# Delete all stopped containers (including data-only containers).
docker ps -a | grep Exited | awk '{print $1}' | xargs docker rm

# Delete all tagged images more than a month old
# (will fail to remove images still used).
docker images --no-trunc --format '{{.ID}} {{.CreatedSince}}' | grep ' weeks' | awk '{ print $1 }' | xargs --no-run-if-empty docker rmi || true
docker images --no-trunc --format '{{.ID}} {{.CreatedSince}}' | grep ' months' | awk '{ print $1 }' | xargs --no-run-if-empty docker rmi || true
docker images --no-trunc --format '{{.ID}} {{.CreatedSince}}' | grep ' years' | awk '{ print $1 }' | xargs --no-run-if-empty docker rmi || true

# Delete all 'untagged/dangling' (<none>) images
# Those are used for Docker caching mechanism.
docker images -q --no-trunc --filter dangling=true | xargs --no-run-if-empty docker rmi

# Delete all dangling volumes.
docker volume ls -qf dangling=true | xargs --no-run-if-empty docker volume rm
