[![ci](https://github.com/icydigital/coinwatch/workflows/ci/badge.svg)[release](https://github.com/icydigital/coinwatch/workflows/release/badge.svg)](https://github.com/icydigital/coinwatch/actions)

# coinwatch

```
./coinwatch -s $(date +"%Y-%m-%d") true
```

### cronjob

add daily cron job

```
crontab -e
0 0,8,16 * * * ./coinwatch -s $(date +"%Y-%m-%d") true
```

<!--
APIs:
- Coinapi
- Nomics
- Messari
 -->
