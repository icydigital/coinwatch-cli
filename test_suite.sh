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

test_coinwatch_get_list_of_exchanges_by_date_200() {
  printf "test_get_list_of_exchanges_by_date_200\n"

  resp_head="$(mktemp)"
  resp_body="$(mktemp)"
  date=$1

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
  dummy_resp_body="$(mktemp)"
  date=$1

  ./coinwatch.sh $date >> $resp_body
  expexted_string="Token Store 2017-09-17"

  cat $resp_body

  # if grep -xq "$expexted_string" "$resp_body";
  # then
  #   printf "response does match expected string\n"
  # else
  #   exit 1
  # fi
  #
  # echo "dummy" >> $dummy_resp_body
  #
  # if grep -xq "$expexted_string" "$dummy_resp_body";
  # then
  #   exit 1
  # else
  #   printf "dummy response does not match expected string\n"
  # fi
}

test_coinwatch_sh_notification() {
  printf "test_coinwatch_notification\n"

  resp_body="$(mktemp)"

  ./coinwatch.sh $date $2 >> $resp_body
}
