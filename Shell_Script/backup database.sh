#!/bin/sh

datenow=`date '+%Y-%m-%d'`

echo Start backup DB
/usr/bin/mysqldump -uroot -pP@ssword123 -h127.0.0.1 --databases gem_core > /opt/backupdb/data/gem_core_db1_$datenow.sql
/usr/bin/mysqldump -uroot -pP@ssword123 -h127.0.0.1 --databases gem_hbus_admin > /opt/backupdb/data/gem_hbus_admin_db1_$datenow.sql
/usr/bin/mysqldump -uroot -pP@ssword123 -h127.0.0.1 --databases gem_hbus_connector > /opt/backupdb/data/gem_hbus_connector_db1$datenow.sql
echo Start zip and move to backup folder
gzip -9 /opt/backupdb/data/*$datenow.sql
sleep 60

exit 0

