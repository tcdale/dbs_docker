#!/usr/bin/bash
clear
function message {
  echo -e "\n### $1\n"
}
function wait {
    for i in `seq 1 $1`;
    do
        echo '.'
        sleep 1
    done   
}
function run_core_cmd {
    docker exec dbs-core $1
}
function run_core_artisan_cmd {
    run_core_cmd "php artisan $1"
}
#
# Shutdown and Clean up first
#
message 'Compose Down'
COMPOSE_DIR='/root/dbs/code/dbs_docker/docker-compose'
COMPOSE_FILE="${COMPOSE_DIR}/docker-compose.yml"
docker-compose -f $COMPOSE_FILE down
message 'Delete old dbs-database files'
rm -rf /var/lib/docker/volumes/dbs_db/*
#
# Set exec on files
#
chmod 700 /root/dbs/code/dbs_snapper/*.php
#
# Start system
#
message 'Compose create'
docker-compose -f $COMPOSE_FILE up --force-recreate -d
#
# Check logs
#
docker-compose -f $COMPOSE_FILE logs
#
# Build database schema
#
message "Gen new appication key"
run_core_artisan_cmd key:generate

message "Copy application key and password to the snapper for decrypt"
APP_KEY=`run_core_cmd "grep APP_KEY .env"`
APP_KEY=`echo "$APP_KEY" | awk '{split($0,a,"="); print a[2]}'`
REPO_PASSWORD=`grep dbs_password $COMPOSE_FILE`
REPO_PASSWORD=`echo "$REPO_PASSWORD" | awk '{split($0,a,"="); print a[2]}'`
message "APP_KEY : $APP_KEY"
message "DB PW   : $REPO_PASSWORD"
DBS_SNAPPER='dbs-snapper'
docker exec -i $DBS_SNAPPER bash -c "echo '$APP_KEY' > app_key.txt"
docker exec -i $DBS_SNAPPER bash -c "echo '$REPO_PASSWORD' > repo_pw.txt"

message "Build schema"
run_core_artisan_cmd migrate
message "Restart Snapper now database created"
docker restart $DBS_SNAPPER
message "Done"
