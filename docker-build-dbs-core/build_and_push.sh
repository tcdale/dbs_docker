#!/bin/sh
echo "Rebuild container"
#docker build --no-cache -t dbs-core .
docker build -t dbs-core .
echo "Tag"
docker tag dbs-core tomdale55/dbs-core
echo "Push"
docker push tomdale55/dbs-core
