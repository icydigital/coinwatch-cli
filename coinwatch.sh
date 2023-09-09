#!/bin/bash
# source .env # enable only for local testing

get_coins_cmc () {
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

    if [ -z "$1" ]; then
      curl -H "X-CMC_PRO_API_KEY: $X_CMC_PRO_API_KEY" \
        -H "Accept: application/json" \
        -D $resp_head \
        -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/map | \
        jq -r '.data | .[] | .name + " " + .first_historical_data'
       >> $resp_body
    else
      curl -H "X-CMC_PRO_API_KEY: $X_CMC_PRO_API_KEY" \
        -H "Accept: application/json" \
        -D $resp_head \
        -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/map | \
        jq -r '.data | .[] | .name + " " + .first_historical_data' | \
        grep "$1"
       >> $resp_body
    fi
}

coinwatch () {
  if [ -z "$1" ]; then
    get_coins_cmc
  else
    get_coins_cmc $1
  fi
  cat "$resp_body"
}

message="$(mktemp)"
if [ -z "$1" ]; then
  coinwatch >> $message
  message_header="Cryptocurrencies by first available date:"
  echo $message_header && cat "$message"
else
  coinwatch $1 >> $message
  if [ -s $message ]; then
    message_header="New crypto currencies introduced today: $1"
    echo $message_header && cat "$message"
  else
    message_header="-- - No new crypto currencies on $1 ---"
    echo $message_header
  fi
fi
