#!/bin/bash
test_get_exchanges_200() {
  printf "test_get_exchanges_200\n"
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  X_COIN_API_KEY=$1

  curl -sS https://rest.coinapi.io/v1/exchanges \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head
  >> $resp_body

  assert_status $resp_head 200
}

test_get_list_of_exchanges_by_date() {
  printf "test_get_list_of_exchanges_by_date\n"
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"
  date=$(date)

  X_COIN_API_KEY=$1

  curl -sS https://rest.coinapi.io/v1/exchanges \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head | \
    jq '.[] | "\(.name) \(.data_start)"' | \
    grep "$date"
  >> $resp_body

  assert_status $resp_head 200
}
