#!/bin/bash
date_today=$(date +"%Y-%m-%d")

watch_cmc () {
  resp_head_cmc="$(mktemp)"
  resp_body_cmc="$(mktemp)"

  if [[ -v $1 ]]; then
    curl -sS "https://rest.coinapi.io/v1/exchanges" \
      -X GET \
      --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
      -D $resp_head_cmc | \
      jq -r '.[] | .name + " " + .data_start' | \
      grep "$date_today" \
    >> $resp_body_cmc
  else
    curl -sS "https://rest.coinapi.io/v1/exchanges" \
      -X GET \
      --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
      -D $resp_head_cmc | \
      jq -r '.[] | .name + " " + .data_start' \
    >> $resp_body_cmc
  fi
}

watch_nomics () {
  resp_head_nomics="$(mktemp)"
  resp_body_nomics="$(mktemp)"

  if [[ -v $1 ]]; then
    curl -sS "https://api.nomics.com/v1/currencies/ticker?key=$NOMICS_API_KEY" \
      -X GET \
      -D $resp_head_nomics | \
      jq -r '.[] | select(.first_trade != null) | .name + " " + .first_trade' | \
      grep "$date_today" | \
      rev | cut -c11- | rev \
    >> $resp_body_nomics
  else
    curl -sS "https://api.nomics.com/v1/currencies/ticker?key=$NOMICS_API_KEY" \
      -X GET \
      -D $resp_head_nomics | \
      jq -r '.[] | select(.first_trade != null) | .name + " " + .first_trade' | \
      # grep "$date_today" | \
      rev | cut -c11- | rev \
    >> $resp_body_nomics
  fi
}

watch_massari () {
  resp_head_massari="$(mktemp)"
  resp_body_massari="$(mktemp)"

  if [[ -v $1 ]]; then
    curl -sS "https://data.messari.io/api/v2/assets" \
      -X GET \
      -D $resp_head_massari | \
      jq -r '.data | .[].name + " " + .[].profile.economics.launch.initial_distribution.token_distribution_date' | \
      grep "$date_today" | \
      rev | cut -c11- | rev \
    >> $resp_body_massari
  else
    curl -sS "https://data.messari.io/api/v2/assets" \
      -X GET \
      -D $resp_head_massari | \
      jq -r '.data | .[].name + " " + .[].profile.economics.launch.initial_distribution.token_distribution_date' | \
      # grep "$date_today" | \
      rev | cut -c11- | rev \
    >> $resp_body_massari
  fi
}

get_coins () {
  resp_body="$(mktemp)"
  # watch_nomics $date_today
  watch_cmc $date_today
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

if [ -s $message ]; then
  message_header="New crypto currencies introduced today: $date_today"
  echo $message_header && cat $message
else
  message_header="-- - No new crypto currencies on $date_today ---"
  echo $message_header
fi
# notify-send "$(echo $message_header)" "$(cat "$message")"
