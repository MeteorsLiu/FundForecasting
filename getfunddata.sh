#This file helps you get real time fund data from eastmoney and output to csv for pandas covering to dataframe
#System Requirement: jq,curl,dateutils
#Usage: bash getfunddata.sh

time=$(date +%s)
curl -o a.txy -s "http://api.fund.eastmoney.com/f10/lsjz?fundCode=001475&pageIndex=1&pageSize=1000&startDate=2020-08-18&endDate=2021-08-25&_=$time" \
  -H 'Proxy-Connection: keep-alive' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36 Edg/92.0.902.78' \
  -H 'Accept: */*' \
  -H 'Referer: http://fundf10.eastmoney.com/' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H 'Cookie: qgqp_b_id=83a01b50caa8d46ab241ba7d00c1ab14; intellpositionL=1176.95px; intellpositionT=455px; EMFUND1=null; EMFUND2=null; EMFUND3=null; EMFUND4=null; EMFUND5=null; EMFUND6=null; EMFUND7=null; EMFUND0=null; EMFUND8=08-23%2017%3A45%3A56@%23%24%u6613%u65B9%u8FBE%u84DD%u7B79%u7CBE%u9009%u6DF7%u5408@%23%24005827; st_si=42853515810908; st_asi=delete; EMFUND9=08-25 14:58:08@#$%u6613%u65B9%u8FBE%u56FD%u9632%u519B%u5DE5%u6DF7%u5408@%23%24001475; st_pvi=33692283506244; st_sp=2021-07-26%2023%3A38%3A17; st_inirUrl=https%3A%2F%2Fwww.google.com.hk%2F; st_sn=4; st_psi=2021082515004266-112200305283-8883641859' \
  --compressed \
  --insecure

printf "GID\tTIME\tJZ\n" >> t.csv
JZ=($(jq -r '.Data .LSJZList | .[].JZZZL' < a.txy))
TIME=($(jq -r '.Data .LSJZList | .[].FSRQ' < a.txy ))
groups=0
for i in ${!JZ[*]}; do
     DATE=$(datediff 2020-8-18 ${TIME[i]})
     [[ "$i" -gt 0 ]] && [[ "$(datediff ${TIME[i]} ${TIME[$((i-1))]})" -gt 3 ]] && let groups++
     printf "$groups\t$DATE\t${JZ[i]}\n" >> t.csv
done
