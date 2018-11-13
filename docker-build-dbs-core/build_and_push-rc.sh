#!/bin/sh
echo "Rebuild container"
docker build -f /root/dbs/code/dbs_docker/docker-build-dbs-core/Dockerfile-rc -t dbs-core-rc .
echo "Tag"
docker tag dbs-core-rc tomdale55/dbs-core-rc
#echo "Push"
#docker push tomdale55/dbs-core-rc
