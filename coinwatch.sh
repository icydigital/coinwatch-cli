#!/bin/bash

date=$1
notifier=$2
message="$(mktemp)"

watch_cmc () {
  resp_head_cmc="$(mktemp)"
  resp_body_cmc="$(mktemp)"

  curl -sS "https://rest.coinapi.io/v1/exchanges" \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head_cmc \
    # jq -r '.[] | "\(.name) \(.data_start)"' | \
    # grep "$1" \
  >> $resp_body_cmc
}

watch_nomics () {
  resp_head_nomics="$(mktemp)"
  resp_body_nomics="$(mktemp)"

  curl -sS "https://api.nomics.com/v1/currencies/ticker?key=$NOMICS_API_KEY" \
    -D $resp_head_nomics \
  >> $resp_body_nomics
}

get_coins () {
  watch_cmc
  cat $resp_body_cmc
}

coinwatch () {
  get_coins
}

if [ -z "$notifier" ]
then
  coinwatch $date
else
  coinwatch $date >> $message
  notify-send "New coins on: $date" "$(cat "$message")"
fi
