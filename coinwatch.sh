#!/bin/bash
x_coin_api_key=$1
date=$2
resp_head="$(mktemp)"
resp_body="$(mktemp)"

curl -sS https://rest.coinapi.io/v1/exchanges \
  -X GET \
  --header "X-CoinAPI-Key: $x_coin_api_key" \
  -D $resp_head |
  jq '.[] | "\(.name) \(.data_start)"' | \
  grep "$date" \
>> $resp_body
