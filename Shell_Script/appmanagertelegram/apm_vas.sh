#!/bin/bash

homeapp="/home/oracle/script";
cd $homeapp;

. ./lib_telegram.sh

apiUrl="http://125.212.225.220:9802/AppManager/xml/ListAlarms?apikey=e0a7242601599fc14f1c134a7a63f597&topN=5&type=allmonitors"

xmlData="$homeapp/xml_apm_vas.xml";
echo '' > $xmlData;

now=$(date +'%Y/%m/%d %H:%M:%S');

#echo "$now - APM: call APM API";

curl -X GET  $apiUrl -o $xmlData ;

#sleep 30

XML="xmlstarlet sel -t -v"

qBase="//Alarm[@STATUS!='clear']";
qName="$qBase/@DISPLAYNAME";
qCount="count($qName)";

xCount=$($XML $qCount $xmlData);
iName=$($XML $qName $xmlData);

echo "$now - APM: Call APM-VAS api, found $xCount warning items with Name: '$iName'" ;

if [[ $xCount -eq 0 ]]; then
   echo "$now - APM: no data found";

else
   echo "$now - APM: connect ok";
   messages="";

   if [[ $xCount -gt 1 ]]; then
	echo "count more than 1";
   
        i=1;
        while [ $i -le $xCount ]
        do
                iDate=$($XML "$qBase[$i]/@FORMATTEDDATE" $xmlData );
                iMsg=$($XML "$qBase[$i]/@MESSAGE" $xmlData );
                iName=$($XML "$qBase[$i]/@DISPLAYNAME" $xmlData );

                iMsg="${iMsg//&lt;br&gt;/%0A}";
                iMsg="${iMsg//&gt;/>}";

                messages="$messages %0A[$i]$iName has issues at $iDate, Messages:$iMsg";
                ((i++));
#                echo $i;
        done ;

   else
 	iDate=$($XML "$qBase/@FORMATTEDDATE" $xmlData );
   	iMsg=$($XML "$qBase/@MESSAGE" $xmlData );

   	messages="%0A$iName has issues at DATE: $iDate, MESSAGE:%0A $iMsg";
        messages="${messages//&lt;br&gt;/%0A}";
        messages="${messages//&gt;/>}";
   fi

   messages="$now - APM - details: $messages";
   echo $messages;
   send_msg3 "$messages" "@amssms8xmonitor";

fi

