[![ci](https://github.com/icydigital/coinwatch-cli/workflows/ci/badge.svg)](https://github.com/icydigital/coinwatch-cli/actions)[![release](https://github.com/icydigital/coinwatch-cli/workflows/release/badge.svg)](https://github.com/icydigital/coinwatch-cli/actions)

# coinwatch-cli

wip

```
chmod +x ./coinwatch && ./coinwatch
```

## Use Cases

### cronjob

add daily cron job

```
crontab -e
0 0,8,16 * * * ./coinwatch
```

<!--
APIs:
- Coinapi test_get_exchanges_coinapi_200
- Nomics test_get_exchanges_nomics_200
- Messari test_get_exchanges_messari_200
 -->
