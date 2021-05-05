#!/bin/bash
source ./.env
x_coin_api_key=$(echo $1 | base64 --decode)
date=$2

x_coin_payload=$(curl -s https://rest.coinapi.io/v1/exchanges \
  -X GET \
  -H "X-CoinAPI-Key: $x_coin_api_key" | \
  jq '.[] | "\(.name) \(.data_start)"' | \
  grep "$date"
>> /dev/null)

echo $x_coin_payload
