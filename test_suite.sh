#!/bin/bash
test_get_exchanges_200() {
  printf "test_get_exchanges_200\n"
  resp_head="$(mktemp)"

  X_COIN_API_KEY=$1

  curl -sS https://rest.coinapi.io/v1/exchanges \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head \
  >> /dev/null

  assert_status $resp_head 200
}


test_coinwatch_get_list_of_exchanges_by_date() {
  printf "test_get_list_of_exchanges_by_date\n"
  resp_head="$(mktemp)"
  resp_body="$(mktemp)"
  X_COIN_API_KEY=$1
  date=$2

  curl -sS https://rest.coinapi.io/v1/exchanges \
    -X GET \
    --header "X-CoinAPI-Key: $X_COIN_API_KEY" \
    -D $resp_head | \
    jq -r '.[] | "\(.name) \(.data_start)"' | \
    grep "$date" \
  >> $resp_body

  expexted_string="Token Store 2017-09-17"

  assert_status $resp_head 200
  if grep -xq "$expexted_string" "$resp_body"; then
    cat "$resp_body"
  fi
}

test_coinwatch_sh() {
  printf "test_coinwatch_sh\n"
  resp_body="$(mktemp)"
  X_COIN_API_KEY=$1
  date=$2

  resp_body=$(./coinwatch.sh $X_COIN_API_KEY $date)
  expexted_string="Token Store 2017-09-17"

  if grep -xq "$expexted_string" "$resp_body"; then
    cat "$resp_body"
  fi
}
