#!/bin/bash
PROCESSNAME=''
HL=10
 
IFS=$'\n'
L=$(ps aux | grep $PROCESSNAME)
for fn in $L; do
        PID=$(echo $fn | awk '{print $2'})
        LOAD=$(echo $fn | awk '{print $3'})
        if [ $(echo "$LOAD > $HL" | bc -l ) -eq 1 ]
        then
                kill -9 $PID
                echo "Killed $PID"
        fi
done