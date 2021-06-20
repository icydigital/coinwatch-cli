[![ci](https://github.com/icydigital/coinwatch/workflows/ci/badge.svg)](https://github.com/icydigital/coinwatch/actions)

# coinwatch

```
curl -s https://raw.githubusercontent.com/icydigital/coinwatch/main/coinwatch.sh | bash -s $(date +"%Y-%m-%d") true
```

### cronjob

add daily cron job

```
crontab -e
0 0,8,16 * * * curl -s https://raw.githubusercontent.com/icydigital/coinwatch/main/coinwatch.sh | bash -s $(date +"%Y-%m-%d") true
```

<!--
APIs:
- Coinapi
- Nomics
- Messari
 -->
