#!/bin/bash
source ./.env
today=$(date '+%Y-%m-%d')

X_coin=$(curl -s https://rest.coinapi.io/v1/exchanges \
  --header "X-CoinAPI-Key: $X_COIN_API_KEY" | \
  jq '.[] | "\(.name) \(.data_start)"' | \
  grep "$today"
>> /dev/null)

Coingecko=$(curl -s https://coingecko.p.rapidapi.com/exchanges \
	--header "x-rapidapi-host: coingecko.p.rapidapi.com" \
	--header "x-rapidapi-key: $COIN_GECKO" | \
  jq '.[]'
>> /dev/null)

echo "$X_coin"
echo "$Coingecko"

if [ -s "$X_Coin" ] && [ -s "$Coingecko"]
then
  notify-send "No new cryptocurrencies were introduced today"
else
  notify-send "The following cryptocurrencies were introduced today:
  ===========
  $(echo $X_Coin $Coingecko)"
fi
