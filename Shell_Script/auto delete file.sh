homedir=/opt/backupdb/data
datenow=`date '+%Y-%m-%d'`
#olddate=`date '+%Y-%m-%d' -d "1 day ago"`
secondlastDay=`date '+%Y-%m-%d' -d "2 day ago"`
cd $homedir
echo $secondlastDay
## Xoa file theo ten file.
/bin/rm -rf *$secondlastDay*
sleep 5
echo Delete_file_OK_$datenow >> /opt/backupdb/data/log_delete_sysdate2.txt
exit 0

