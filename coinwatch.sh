#!/bin/bash

date=$1
notifier=$2
message="$(mktemp)"

watch_coinmarketcap () {
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  curl -sS https://rest.coinapi.io/v1/exchanges \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head |
    jq -r '.[] | "\(.name) \(.data_start)"' | \
    grep "$1" \
  >> $resp_body
}

watch_nomics () {
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  curl -sS https://api.nomics.com/v1/currencies/ticker \
    -X GET \
    --header "key: $NOMICS_API_KEY" \
    -D $resp_head \
  >> $resp_body
}

get_coins () {
  watch_coinmarketcap $date
}

coinwatch () {
  get_coins $date
}

if [ -z "$notifier" ]
then
  coinwatch $date
else
  coinwatch $date >> $message
  notify-send "New coins on: $date" "$(cat "$message")"
fi
