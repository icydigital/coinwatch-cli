#!/bin/bash
source ./.env
# today=$(date '+%Y-%m-%d')

X_coin=$(curl -s https://rest.coinapi.io/v1/exchanges \
  -X GET \
  -H "X-CoinAPI-Key: $X_COIN_API_KEY" | \
  jq '.[] | "\(.name) \(.data_start)"' | \
  grep "$1"
>> /dev/null)

echo $X_coin
notify-send "new" "$X_coin"
