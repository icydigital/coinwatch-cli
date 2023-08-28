#!/bin/bash
source .env

resp_head_cmc="$(mktemp)"
resp_body_cmc="$(mktemp)"

curl -sS "https://rest.coinapi.io/v1/exchanges" \
  -X GET \
  --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
  -D $resp_head_cmc | \
  jq -r '.[] | .name + " " + .data_start' \
>> $resp_body_cmc

cat $resp_body_cmc 
