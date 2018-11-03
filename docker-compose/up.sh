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
    docker exec dockercompose_dbs-core-php_1 $1
}
function run_core_artisan_cmd {
    run_core_cmd "php artisan $1"
}
#
# Shutdown and Clean up first
#
message 'Compose Down'
docker-compose down
message 'Delete old dbs-database files'
rm -rf /var/lib/docker/volumes/dbs_db/*
#
# Start system
#
message 'Compose create'
docker-compose up --force-recreate -d
#
# Check logs
#
docker-compose logs
#
# Build database schema
#
message "Gen new appication key"
run_core_artisan_cmd key:generate

message "Copy application key and password to the snapper for decrypt"
APP_KEY=`run_core_cmd "grep APP_KEY .env"`
APP_KEY=`echo "$APP_KEY" | awk '{split($0,a,"="); print a[2]}'`
REPO_PASSWORD=`grep dbs_password docker-compose.yml`
REPO_PASSWORD=`echo "$REPO_PASSWORD" | awk '{split($0,a,"="); print a[2]}'`
message "APP_KEY : $APP_KEY"
message "DB PW   : $REPO_PASSWORD"
docker exec -i dockercompose_dbs-snapper_1 bash -c "echo '$APP_KEY' > app_key.txt"
docker exec -i dockercompose_dbs-snapper_1 bash -c "echo '$REPO_PASSWORD' > repo_pw.txt"

message "Build schema"
run_core_artisan_cmd migrate
message "Restart Snapper now database created"
docker restart dockercompose_dbs-snapper_1
message "Done"