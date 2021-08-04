
#!/bin/bash
serv=kannel
DATE_EXEC="$(date "+%d %b %Y %H:%M")"
A="ps -ef | grep -v grep | grep $serv | wc -l"
while read output; do
	echo $output
if [[ "$output" == 0 ]]; then
	#statements
fi
done
then
	echo "$serv is running!!!"
else
	service $serv restart
	echo "$serv service is restarted at $DATE_EXEC" >> kannelrestartlog.txt
fi

