#!/bin/bash

IMAGE_TAG="testautomation-ms:1.3"
NAME_TAG="smoketest"

show_off()
{
  echo "____ _  _ ____ _  _ ____ ___ ____ ____ ___ "
  echo "[__  |\/| |  | |_/  |___  |  |___ [__   |  "
  echo "___] |  | |__| | \_ |___  |  |___ ___]  |  "
  echo "Chuck Norris does NOT use a computer, because a computer does everything slower than Chuck Norris."
  python3 ./cnmod/quoteoftheday.py
}

spinner()
{
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

show_off
echo -ne "\x0a[*] building the image...may take a while ~ 2-3mins, look @za spinner meanwhile => "
docker build -q -t $IMAGE_TAG . &
spinner $!

echo -ne "\x0a[*] starting selenium grid..."
docker network create grid \
  && docker run -d -p 4444:4444 --net grid --name $NAME_TAG-selenium-hub selenium/hub:3.13.0-argon \
  && docker run -d --net grid -e HUB_HOST=$NAME_TAG-selenium-hub -v /dev/shm:/dev/shm --name $NAME_TAG-selenium-node-chrome selenium/node-chrome:3.13.0-argon

echo "[*] add pysmoketest container to the grid and exec the test..."
docker run -itd --name $NAME_TAG-quark --net grid $IMAGE_TAG \
  && sleep 5 \
  && docker exec -it $NAME_TAG-quark /usr/bin/python3 /opt/pytest/google_smoke_test.py

echo "[.] cleanup after the test run..."
docker ps -a --format '{{.Names}}'  | grep --color=auto $NAME_TAG | xargs docker stop
docker ps -a --format '{{.Names}}'  | grep --color=auto $NAME_TAG | xargs docker rm
docker rmi $IMAGE_TAG
docker network prune -f

echo "[*] Done"
