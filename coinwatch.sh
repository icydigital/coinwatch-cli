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

main () {
  if [ -z "$1" ]; then
    payload=$(coinwatch)
    payload_message="Cryptocurrencies by first available date:"
  else
    payload=$(coinwatch $1)
    payload_message="Cryptocurrencies by date $1:"
  fi

  RESP_BODY=$(jq --null-input \
    --arg message "$payload_message" \
    --arg data "$payload" \
    '{"message": $message, "data": $data}')

  echo $RESP_BODY

}

if [ -z "$1" ]; then
  main
else
  main $1
fi
