[![ci](https://github.com/icydigital/coinwatch/workflows/ci/badge.svg)](https://github.com/icydigital/coinwatch/actions)

# coinwatch

alert for new crypto coins
add shell script as a cronjob  

### cronjob

adds daily cronjob
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
