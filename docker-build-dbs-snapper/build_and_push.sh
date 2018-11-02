#!/bin/sh
echo "Rebuild container"
docker build --no-cache -t dbs-snapper .
echo "Tag"
docker tag dbs-snapper datawerks/dbs_snapper
echo "Push"
docker push datawerks/dbs_snapper
