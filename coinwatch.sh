#!/bin/bash
# test -f ./.env && source ./.env
X_COIN_API_KEY="D9CEE857-9F32-42BD-A01B-0774DFD65EB3"
NOMICS_API_KEY="e1cb22a6e8b5b4fbe699353f2398d1ce66c9bfe2"
date_today=$(date +"%Y-%m-%d")

watch_cmc () {
  resp_head_cmc="$(mktemp)"
  resp_body_cmc="$(mktemp)"

  curl -sS "https://rest.coinapi.io/v1/exchanges" \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head_cmc | \
    jq -r '.[] | .name + " " + .data_start' | \
    grep "$date_today" \
  >> $resp_body_cmc
}

watch_nomics () {
  resp_head_nomics="$(mktemp)"
  resp_body_nomics="$(mktemp)"

  curl -sS "https://api.nomics.com/v1/currencies/ticker?key=$NOMICS_API_KEY" \
    -X GET \
    -D $resp_head_nomics | \
    jq -r '.[] | select(.first_trade != null) | .name + " " + .first_trade' | \
    grep "$date_today" | \
    rev | cut -c11- | rev \
  >> $resp_body_nomics
}

watch_massari () {
  resp_head_massari="$(mktemp)"
  resp_body_massari="$(mktemp)"

  curl -sS "https://data.messari.io/api/v2/assets" \
    -X GET \
    -D $resp_head_massari | \
    jq -r '.data | .[].name + " " + .[].profile.economics.launch.initial_distribution.token_distribution_date' | \
    grep "$date_today" | \
    rev | cut -c11- | rev \
  >> $resp_body_massari
}

get_coins () {
  resp_body="$(mktemp)"
  watch_cmc $date_today
  watch_nomics $date_today
  watch_massari $date_today
  cat "$resp_body_cmc" "$resp_body_nomics" "$resp_body_massari" | sort >> $resp_body
}

coinwatch () {
  get_coins $date_today
  cat "$resp_body"
}

message_header="New coins on: $date_today"
message="$(mktemp)"

coinwatch >> $message

if [ -s message ]; then
  message_header="--- No new crypto currencies on $date_today ---"
  echo $message_header
else
  message_header="New crypto currencies on: $date_today"
  echo $message_header && cat $message
fi
# notify-send "$(echo $message_header)" "$(cat "$message")"
