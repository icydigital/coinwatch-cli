#!/bin/bash
# source .env # enable only for local testing

get_coins_cmc () {
  cmc_resp_head="$(mktemp)"
  cmc_resp_body="$(mktemp)"

    if [ -z "$1" ]; then
      curl -H "X-CMC_PRO_API_KEY: $X_CMC_PRO_API_KEY" \
        -H "Accept: application/json" \
        -D $cmc_resp_head \
        -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/map | \
        jq -r '.data | .[] | .name + " " + .first_historical_data'
       >> $cmc_resp_body
    else
      curl -H "X-CMC_PRO_API_KEY: $X_CMC_PRO_API_KEY" \
        -H "Accept: application/json" \
        -D $cmc_resp_head \
        -G https://pro-api.coinmarketcap.com/v1/cryptocurrency/map | \
        jq -r '.data | .[] | .name + " " + .first_historical_data' | \
        grep "$1"
       >> $cmc_resp_body
    fi
}

coinwatch () {
  if [ -z "$1" ]; then
    get_coins_cmc
  else
    get_coins_cmc $1
  fi
  cat "$cmc_resp_body"
}

resp_body="$(mktemp)"
if [ -z "$1" ]; then
  coinwatch >> "$payload"
  payload_message="Cryptocurrencies by first available date:"
  # echo $payload_message && cat "$payload"
else
  coinwatch $1 >> "$payload"
  if [ -s $payload ]; then
    payload_message="New crypto currencies introduced today: $1"
    # echo $payload_message && cat "$payload"
  else
    payload_message="-- - No new crypto currencies on $1 ---"
    # echo $payload_message
  fi
fi

RESP_BODY=$(jq --null-input \
  --arg message "$payload_message" \
  --arg result "$payload" \
  '{"payload_message": $message, "payload": $result}')


echo "JSON response body"
echo $RESP_BODY
