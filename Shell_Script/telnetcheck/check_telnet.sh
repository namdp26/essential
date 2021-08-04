#!/bin/bash
exec > telnetall.txt
echo "<--table Telnetall_3thrd starts-->"
echo "3rd_party= result"
echo  "10.159.26.92 8443
10.159.26.92 9090
10.159.26.92 80
10.159.26.92 10000
10.159.26.92 443" | (
  TCP_TIMEOUT=3
  while read host port; do
    (CURPID=$BASHPID;
    (sleep $TCP_TIMEOUT;kill $CURPID) &
    exec 3<> /dev/tcp/$host/$port
    ) 2>/dev/null
    case $? in
    0)
      echo $host $port = open;;
    1)
      echo $host $port = closed;;
    143) # killed by SIGTERM
       echo $host $port = timeouted;;
     esac
  done
  ) 2>/dev/null # avoid bash message "Terminated ..."
echo "<--table Telnetall_3thrd ends-->"