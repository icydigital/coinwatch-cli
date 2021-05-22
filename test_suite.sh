#!/bin/bash
test_get_exchanges_coinmarketcap_200() {
  printf "test_get_exchanges_coinmarketcap_200\n"

  resp_head="$(mktemp)"

  curl -sS "https://rest.coinapi.io/v1/exchanges" \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head \
  >> /dev/null

  assert_status $resp_head 200
}

test_get_exchanges_nomics_200() {
  printf "test_get_exchanges_nomics_200\n"

  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  curl -sS "https://api.nomics.com/v1/currencies/ticker?key=$NOMICS_API_KEY" \
    -D $resp_head \
  >> $resp_body

  assert_status $resp_head 200
}

test_coinwatch_sh() {
  printf "test_coinwatch_sh\n"

  resp_body="$(mktemp)"
  dummy_resp_body="$(mktemp)"
  date=$1

  ./coinwatch.sh $date >> $resp_body

  cat $resp_body
}

test_coinwatch_sh_notification() {
  printf "test_coinwatch_notification\n"
  date=$1
  notifier=$2

  ./coinwatch.sh $date $notifier >> $resp_body

  cat $resp_body
}
