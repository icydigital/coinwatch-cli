#!/bin/bash
x_coin_api_key=$1
date=$2
notifier=$3
message="$(mktemp)"

coinwatch () {
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  curl -sS https://rest.coinapi.io/v1/exchanges \
    -X GET \
    --header "X-CoinAPI-Key: $x_coin_api_key" \
    -D $resp_head |
    jq -r '.[] | "\(.name) \(.data_start)"' | \
    grep "$date"
  >> $resp_body
}

if [ -z "$notifier" ]
then
  coinwatch $1 $2
else
  coinwatch $1 $2 >> $message
  zenity --notification --text="$(cat "$message")"
fi
