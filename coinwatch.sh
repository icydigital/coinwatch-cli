#!/bin/bash
date=$1
notifier=$2
message="$(mktemp)"

coinwatch () {
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  curl -sS https://rest.coinapi.io/v1/exchanges \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head |
    jq -r '.[] | "\(.name) \(.data_start)"' | \
    grep "$date"
  >> $resp_body
}

if [ -z "$notifier" ]
then
  coinwatch $1
else
  coinwatch $1 $2 >> $message
  notify-send "New coins on: $date" "$(cat "$message")"
fi
