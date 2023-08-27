#!/bin/bash
test_get_exchanges_coinapi_200() {
  printf "test_get_exchanges_coinapi_200\n"

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

  curl -sS "https://api.nomics.com/v1/currencies/ticker?key=$NOMICS_API_KEY" \
    -D $resp_head \
  >> /dev/null

  assert_status $resp_head 200
}

test_get_exchanges_messari_200() {
  printf "test_get_exchanges_messari_200\n"

  resp_head="$(mktemp)"

  curl -sS "https://data.messari.io/api/v2/assets" \
    -D $resp_head \
  >> /dev/null

  assert_status $resp_head 200
}

test_coinwatch_sh() {
  printf "test_coinwatch_sh\n"
  resp_body="$(mktemp)"

  curl -s https://raw.githubusercontent.com/icydigital/coinwatch-cli/main/coinwatch.sh \
  | bash -s >> $resp_body

  cat $resp_body
}
