#!/bin/bash

IMAGE_TAG="testautomation-ms:1.3"
NAME_TAG="smoketest"

echo "[.] cleanup after the test run..."
docker ps -a --format '{{.Names}}'  | grep --color=auto $NAME_TAG | xargs docker stop
docker ps -a --format '{{.Names}}'  | grep --color=auto $NAME_TAG | xargs docker rm 

docker rmi $IMAGE_TAG -f
docker network prune -f

