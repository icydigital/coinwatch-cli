#!/bin/bash
source ./.env
resp_body="$(mktemp)"
today=$(date '+%Y-%m-%d')

curl https://rest.coinapi.io/v1/exchanges \
  --header "X-CoinAPI-Key: $X_COIN_API_KEY" | \
  jq '.[] | "\(.name) \(.data_start)"' | grep "$today"
>> $resp_body
