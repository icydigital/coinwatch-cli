[![ci](https://github.com/icydigital/coinwatch/workflows/ci/badge.svg)](https://github.com/icydigital/coinwatch/actions)

# coinwatch

shell script which observes newly introduced crypto coins by date  

```
~/coinwatch/coinwatch.sh $(date +"%Y-%m-%d")
```

### cronjob

adds daily cronjob with notification

```
crontab -e
0 0,8,16 * * * ~/coinwatch/coinwatch.sh $(date +"%Y-%m-%d") true
```

<!--
APIs:
- Coinapi
- Nomics
- Messari
 -->
