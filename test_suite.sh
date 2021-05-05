#!/bin/bash
test_get_list_of_exchanges_by_date () {
  printf "test_get_list_of_exchanges_by_date\n"
  X_COIN_API_KEY=$1
  PAYLOAD=$(./coinwatch.sh $X_COIN_API_KEY 2015-05-17)
  echo "$PAYLOAD"
  assert_equal $PAYLOAD "BTCTRADE 2015-05-17"
}
