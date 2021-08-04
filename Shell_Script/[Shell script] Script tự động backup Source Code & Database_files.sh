#!/bin/sh

datenow=`date '+%Y-%m-%d'`

echo Start backup gamezone DB
/usr/bin/mysqldump -uroot -pGameRoot123 -h127.0.0.1 --databases vms_gamezone > /opt/backupdb/data/vms_gamezone_db1_$datenow.sql

echo Start zip and move to backup folder
gzip -9 /opt/backupdb/data/*$datenow.sql
sleep 60

exit 0
