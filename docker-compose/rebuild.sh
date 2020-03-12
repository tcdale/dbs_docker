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
# What compose file?
#
COMPOSE_DIR='/root/dbs/code/dbs_docker/docker-compose'
COMPOSE_FILE="${COMPOSE_DIR}/docker-compose.yml"

message "Compose file : ${COMPOSE_FILE}"
#
# Shutdown and Clean up first
#
message 'Compose Down'

docker-compose -f $COMPOSE_FILE down
message 'Delete old dbs-database files'
rm -rf /var/lib/docker/volumes/dbs_db/*
message 'Clear old logs'
rm -rf /root/dbs/logs/*.log
#
# Set exec on files
#
chmod 700 /root/dbs/code/dbs_snapper/*.php
chmod 700 /root/dbs/code/dbs/app/support_files/dbs_scheduler.sh
chmod 700 /root/dbs/code/dbs/app/support_files/*.php
#
# Start system
#
message 'Compose create'
docker-compose -f $COMPOSE_FILE up --force-recreate -d
run_core_cmd "composer update --no-scripts"
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
docker exec -i $DBS_SNAPPER bash -c "echo '$APP_KEY' > .app_key.txt"
docker exec -i $DBS_SNAPPER bash -c "echo '$REPO_PASSWORD' > .repo_pw.txt"
#
# Run the migration when the database is ready
#
run_core_cmd "php wait_for_db_then_migrate.php"
#
# Fix permission
#
run_core_cmd "chmod -R 775 /var/www/html/dbs/storage"
run_core_cmd "chmod -R 775 /var/www/html/dbs/bootstrap/cache"
run_core_cmd "rm -f /var/www/html/dbs/storage/logs/*.log"
#
# Versions
#
message "Laravel :"
run_core_artisan_cmd --version
message "PHP :"
run_core_cmd "php -version"
message "Done"
message "Add to crontab now please"
message "*   * * * * /root/dbs/code/dbs/app/support_files/dbs_scheduler.sh > /root/dbs/logs/dbs_scheduler.log 2>&1"
