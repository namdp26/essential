#!/bin/bash
serv=kannel
DATE_EXEC="$(date "+%d %b %Y %H:%M")"
A=`ps -ef | grep -v grep | grep $serv | wc -l`
if [[ $A -eq 0 ]]; then
	echo "$serv is running!!!"
else
	service $serv restart
	echo "$serv service is restarted at $DATE_EXEC" >> /home/mynhan/kannel/kannelrestartlog.txt
fi


