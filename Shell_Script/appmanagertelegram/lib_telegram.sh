#!/bin/bash

messages='';
REPLY='';
#### function URLENCODE
rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
#  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

##### gui tin nhan qua telegramp
send_msg() {
  rawurlencode "${1}";

  local token="773298442:AAGDP-ASDASDSADASDojcwASDASDASzJiVA"; 

  curl -i -X GET "https://api.telegram.org/bot${token}/sendMessage?parse_mode=html&chat_id=&text=${REPLY}"

  echo "$REPLY"
}


send_msg2() {
  rawurlencode "${1}";

  local chat_id="${2}";

   local token="773298442:AAGDP-ASDASDSADASDojcwASDASDASzJiVA"; 

  curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage?parse_mode=html" -d parse_mode=html  -d chat_id=${chat_id}  -d text="${REPLY}"

  echo "$REPLY"
}


send_msg3() {
#  rawurlencode "${1}";
  REPLY="${1}";

  local chat_id="${2}";

   local token="773298442:AAGDP-ASDASDSADASDojcwASDASDASzJiVA"; 

  curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" -d parse_mode="html" -d chat_id=${chat_id}  -d text="${REPLY}"

  echo "$REPLY"
}






