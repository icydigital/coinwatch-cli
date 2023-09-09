#!/bin/bash
# source .env
# enable only for local testing
# date_today=$(date +"%Y-%m-%d")

# watch_cmc () {
#   resp_head="$(mktemp)"
#   resp_body="$(mktemp)"
#
#   # if [[ -v $1 ]]; then
#     curl -sS "https://data.messari.io/api/v2/assets" \
#       -X GET \
#       -D $resp_head_massari | \
#       jq -r '.data | .[].name + " " + .[].profile.economics.launch.initial_distribution.token_distribution_date' | \
#       grep "$1" | \
#       rev | cut -c11- | rev \
#     >> $resp_body_massari
#   # else
#     curl -sS "https://data.messari.io/api/v2/assets" \
#       -X GET \
#       -D $resp_head_massari | \
#       jq -r '.data | .[].name + " " + .[].profile.economics.launch.initial_distribution.token_distribution_date' | \
#       # grep "$date_today" | \
#       rev | cut -c11- | rev \
#     # >> $resp_body_massari
#   fi
# }

get_coins_cmc () {
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  curl -H "X-CMC_PRO_API_KEY: $X_CMC_PRO_API_KEY" \
    -H "Accept: application/json" \
    -D $resp_head \
    -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/map | \
    jq -r '.data | .[] | .name + " " + .first_historical_data'
   >> $resp_body
}

# get_coins () {
#   resp_body="$(mktemp)"
#   watch_cmc
#   watch_massari
#   cat "$resp_body_cmc" "$resp_body_nomics" "$resp_body_massari" | sort | awk NF >> $resp_body
# }

coinwatch () {
  get_coins_cmc
  cat "$resp_body"
}

message_header="New coins on: $date_today"
message="$(mktemp)"

coinwatch >> $message

if [ -s $message ]; then
  message_header="New crypto currencies introduced today: $date_today"
  echo $message_header && cat "$message"
else
  message_header="-- - No new crypto currencies on $date_today ---"
  echo $message_header
fi
# notify-send "$(echo $message_header)" "$(cat "$message")"
