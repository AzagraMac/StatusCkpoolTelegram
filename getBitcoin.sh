#!/bin/bash

TOKEN="YOUR_TOKEN"
ID="YOUR_CHAT_ID"
WALLET="YOUR_ADDRESS_BTC"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
MSG="฿ Bitcoin"
JSON=$(curl -s -X GET https://solo.ckpool.org/users/$WALLET -H "Accept: application/json" | jq .)
HASHRATE=$(echo $JSON | jq .hashrate1m | sed "s/['\"]//g")
WORKER=$(echo $JSON | jq '.workers')
SHARES=$(echo $JSON | jq '.shares')
BESTSHARE=$(echo $JSON | jq .worker | jq .[].bestever | numfmt --to=iec)
ERROR=$(cat /root/rsyslog/raspberrypi/cgminer.log | grep Rejected | wc -l)
OK=$(cat /root/rsyslog/raspberrypi/cgminer.log | grep Accepted | wc -l)


if [ $? -ne 0 ]
then
        exit 0
else
        /usr/bin/curl -s -X POST $URL \
		-d chat_id=$ID \
		-d parse_mode=HTML \
		-d text="$(printf "$MSG\n\t\t- \U1F4CA Hashrate: <code>$HASHRATE</code>\n\t\t- \U1F517 Shares: <code>$SHARES</code>\n\t\t- \U1F4C8 Bestshare: <code>$BESTSHARE</code>\n\t\t- \U1F4E6 Packages: \n\t\t\t\t\tOK: <code>$OK</code>\n\t\t\t\t\tError: <code>$ERROR</code>\n\t\t- \U26CF Workers: <code>$WORKER</code>")" \
		> /dev/null 2>&1
        exit 0
fi
