#!/bin/bash
x_coin_api_key=$1
date=$2

x_coin_payload=$(curl -s https://rest.coinapi.io/v1/exchanges \
  -X GET \
  --header "X-CoinAPI-Key: $x_coin_api_key" | \
  jq '.[]'
  # jq '.[] | "\(.name) \(.data_start)"' | \
  # grep "$date"
>> /dev/null)

echo $x_coin_payload
