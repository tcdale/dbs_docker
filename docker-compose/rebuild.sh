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
    sudo docker exec dbs-core $1
}
function run_core_artisan_cmd {
    run_core_cmd "php artisan $1"
}
#
# What compose file?
#
COMPOSE_DIR='/home/dbs/code/dbs_docker/docker-compose'
COMPOSE_FILE="${COMPOSE_DIR}/docker-compose.yml"

message "Compose file : ${COMPOSE_FILE}"
#
# Shutdown and Clean up first
#
message 'Compose Down'

sudo docker-compose -f $COMPOSE_FILE down
message 'Delete old dbs-database files'
rm -rf /var/lib/docker/volumes/dbs_db/*
message 'Clear old logs'
rm -rf /home/dbs/logs/*.log
#
# Start system
#
#message 'Compose create'
sudo docker-compose -f $COMPOSE_FILE up --force-recreate -d
message "Laravel :"
sudo run_core_artisan_cmd --version
message "PHP :"
run_core_cmd "php -version"
