#!/bin/sh

# settings
EXPIRY_WARNING="200" # warn if domain expires in less than this days

# error out when env variables are not set
set -u

# text coloring
RED='\e[31m'
GREEN='\e[32m'
BLUE='\e[34m'
RESET='\e[0m'

check_command_exists () {
  if ! command -v $1 &> /dev/null; then
    echo "Error executing $0: '$1' not installed"
    exit -1
  fi
}
check_command_exists 'curl'
check_command_exists 'jq'

# check network connection
RET=$(curl -s -L --head 'https://www.inwx.de/de' -o /dev/null -w '%{http_code}')
if [ $RET -ne 200 ]; then
  echo "Could not connect to inwx.de"
  exit 1
fi

# create tmp file for cookie
COOKIE_JAR=$(mktemp) 

# arguments: 
#   request_method (e.g. 'account.login')
#   request_params (e.g. '{}', '{"lang": "en", ...}'
call_api () {
  REQ_METHOD=$1
  REQ_PARAMS=$2
  REQ_STRING='{"method": "'$REQ_METHOD'", "params": '$REQ_PARAMS'}'

  API_URL='https://api.domrobot.com/jsonrpc/'
  USER_AGENT='DomRobot/3.1.1(Python 3.13.3)' # mimic inwx python wrapper

  # make request
  RET=$(curl -f -s \
    -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
    -H 'Content-Type: application/json' \
    -A "$USER_AGENT" \
    -d "$REQ_STRING" \
    -X POST \
    "$API_URL")
  
  # check return code
  CODE=$(echo $RET | jq .code)
  if [ "$CODE" -ne "1000" ]; then
    echo "Call to $REQ_METHOD unsuccessful! Returned $CODE" >&2
    rm $COOKIE_JAR
    exit -1
  fi

  echo $RET
}

# login
LOGIN_PARAMS='{"lang": "en", "user": "'$INWX_USER'", "pass": "'$INWX_PASS'"}'
call_api 'account.login' "$LOGIN_PARAMS" > /dev/null

# get list of domains
RET=$(call_api 'domain.list' '{}')

# interpret results
CURRENT_TS=$(date +%s)
DOMAIN_LIST=$(echo $RET | jq -c '.resData.domain[]')
echo "$DOMAIN_LIST" | while read -r domain; do
  domain_name=$(echo $domain | jq -r '.domain')
  domain_ex_ts=$(echo $domain | jq -r '.exDate.timestamp')

  diff=$((domain_ex_ts - CURRENT_TS))
  days=$((diff / 86400))

  printf "${BLUE}$domain_name${RESET} expires in "
  if [ "$days" -le "$EXPIRY_WARNING" ]; then
     printf "${RED}"
   else
     printf "${GREEN}"
  fi
  printf "$days days${RESET}\n"
done

# delete cookies
rm $COOKIE_JAR
