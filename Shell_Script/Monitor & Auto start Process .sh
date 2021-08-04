#!/bin/bash
a=`ps -ef | grep "vc-mynhan-charge" | grep -v grep | awk '{print $2}'`
charge=$(($a))

if [ $charge -eq 0 ] ;then
cd /home/mynhanplus/charge
./start.sh
else echo "process running!"
fi
exit 1
