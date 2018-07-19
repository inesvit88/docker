#!/bin/bash

IMAGE_TAG="testautomation-ms:1.3"
echo "[*] build the image... may take a while ~ 2-3mins"
docker build -t $IMAGE_TAG .

echo "[*] start selenium grid..."
docker network create grid \
  && docker run -d -p 4444:4444 --net grid --name selenium-hub selenium/hub:3.13.0-argon \
  && docker run -d --net grid -e HUB_HOST=selenium-hub -v /dev/shm:/dev/shm selenium/node-chrome:3.13.0-argon

echo "[*] add pysmoketest container to the grid and exec the test..."
docker run -itd --name pysmoketest --net grid $IMAGE_TAG \
  && docker exec -it pysmoketest /usr/bin/python3 /opt/pytest/google_conn.py

echo "[*] cleanup after the test run..."
docker ps -a -q | xargs docker stop
docker ps -a -q | xargs docker rm

docker network prune -f

docker rmi $IMAGE_TAG

echo "[*] Done"
