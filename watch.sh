#!/bin/bash
source ./.env
resp_body="$(mktemp)"
today=$(date '+%Y-%m-%d')

coins=$(curl -s https://rest.coinapi.io/v1/exchanges \
  --header "X-CoinAPI-Key: $X_COIN_API_KEY" | \
  jq '.[] | "\(.name) \(.data_start)"' | \
  grep "$today"
>> /dev/null)

if [ -s $coins ]
then
  notify-send "No new cryptocurrencies were introduced today"
else
  notify-send "The following cryptocurrencies were introduced today: $(echo $coins)"
fi
