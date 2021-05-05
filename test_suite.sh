#!/bin/bash
test_x_coin_api_get_exchanges_by_date () {
  printf "test_x_coin_api_get_exchanges_by_date\n"
  payload=(./coinwatch.sh 2015-05-17)
  assert_equal $payload "BTCTRADE 2015-05-17"
}
