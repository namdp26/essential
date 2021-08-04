#!/bin/bash

homeapp="/home/oracle/script";
cd $homeapp;

. ./lib_telegram.sh
 
apiUrl="http://125.212.225.234:9801/AppManager/xml/ListAlarms?apikey=<apikey lay tu Application Manager>&topN=5&type=allmonitors";
xmlData="$homeapp/xml_apm_sub.xml";
echo '' > $xmlData;

now=$(date +'%Y/%m/%d %H:%M:%S');

#echo "$now - APM: call APM API";

curl -X GET  $apiUrl -o $xmlData ;

XML="xmlstarlet sel -t -v"

qBase="//Alarm[@STATUS!='clear']";
qName="$qBase/@DISPLAYNAME";
qCount="count($qName)";

xCount=$($XML $qCount $xmlData);
iName=$($XML $qName $xmlData);

echo "$now - APM: Call APM-Sub api, found $xCount warning with Name: '$iName'" ;

if [[ $xCount -eq 0 ]]; then
   echo "$now - APM: no data found";

else
   echo "$now - APM: connect ok";
   
   messages="";
   messages_test="";
   messages_content="";
	
   count_test=0;
   count_content=0;
   count=0;

   if [[ $xCount -gt 1 ]]; then
	echo "count more than 1";
	
        rowMsg="";
        i=1;
        while [ $i -le $xCount ]
	do  
		iDate=$($XML "$qBase[$i]/@FORMATTEDDATE" $xmlData );
  		iMsg=$($XML "$qBase[$i]/@MESSAGE" $xmlData );
		iName=$($XML "$qBase[$i]/@DISPLAYNAME" $xmlData );

                iMsg="${iMsg//&lt;br&gt;/%0A}";
	        iMsg="${iMsg//&gt;/>}";
                rowMsg="%0A [$i]-$iDate, $iName, $iMsg";
                echo $rowMsg;

		if [[ $iName = *"TEST"* ]]; then
			messages_test="$messages_test %0A $rowMsg";
			((count_test++));

                elif [[ $iName == *"CONTENT"* ]] ; then
			messages_content="$messages_content %0A $rowMsg";
 			((count_content++));
		else
			messages="$messages %0A $rowMsg";
			((count++));
		fi
  #             echo $messages;
                ((i++));
	done ;

   else

   	iDate=$($XML "$qBase/@FORMATTEDDATE" $xmlData );
   	iMsg=$($XML "$qBase/@MESSAGE" $xmlData );

 	if [[ $iName = *"TEST"* ]]
	then
		messages_test="%0A - $iDate, $iName, MESSAGE: $iMsg";
        	messages_test="${messages_test//&lt;br&gt;/%0A}";
        	messages_test="${messages_test//&gt;/>}";
              	count_test=1;

	elif [[ $iName = *"CONTENT"* ]]
	then
                messages_content="%0A - $iDate, $iName, MESSAGE: $iMsg";
                messages_content="${messages_content//&lt;br&gt;/%0A}";
                messages_content="${messages_content//&gt;/>}";
                count_content=1;

        else
		messages="%0A - $iDate, $iName, MESSAGE: $iMsg";
	        messages="${messages//&lt;br&gt;/%0A}";
        	messages="${messages//&gt;/>}";
              	count=1;
        fi

   fi

   if [ $count -gt 0 ]; then
   	messages="$now - APM - details: $messages";
   	echo $messages;
   	send_msg3 "$messages" "<@ChannelID>";
   fi

   if [ $count_test -gt 0 ]; then
 	messages_test="$now - APM - details: $messages_test";
	send_msg3 "$messages_test" "<@ChannelID>";
   fi

   if [ $count_content -gt 0 ]; then
        messages_content="$now - APM - details: $messages_content";
        send_msg3 "$messages_content" "<@ChannelID>";
   fi

fi
