#!/bin/bash
test_get_list_of_exchanges_by_date() {
  printf "test_get_list_of_exchanges_by_date\n"
  X_COIN_API_KEY=$1
  PRELOAD=$(get_x_coin_data $X_COIN_API_KEY 2015)

  PAYLOAD=$(get_x_coin_data $X_COIN_API_KEY 2015)

  echo "$PAYLOAD"
  echo "$PRELOAD"

  diff -u <(echo "$PAYLOAD") <(echo "$PRELOAD")

  assert_equal "$PAYLOAD" "$PRELOAD"
}
