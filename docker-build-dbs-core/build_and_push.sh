#!/bin/sh
echo "Rebuild container"
#docker build --no-cache -t dbs-core-new .
docker build -t dbs-core-new .
echo "Tag"
docker tag dbs-core-new datawerks/dbs:core-php
#echo "Push to quay"
#docker push quay.io/fivium/dbs:core
