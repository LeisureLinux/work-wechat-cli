#!/bin/bash
# #####################################################
# Last modified by: Albert Xu <axu@yj777.cn>
# QQ/WeChat: 8122093
# Last modify date: June 2 2019  
# Shanghai Young Jack Network Technology (上海甬洁网络)
# #####################################################
URL_GET_TOKEN="https://qyapi.weixin.qq.com/cgi-bin/gettoken"
URL_SEND_MSG="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="
CFG=$(dirname $0)/work_wechat.cfg
[ ! -r ${CFG} ] && echo "请先设置好配置文件 $CFG" && exit 2
#
CORP_ID=$(awk -F"=" 'tolower($1) ~ /^corp_id/ {print $2}' $CFG)
SECRET=$(awk -F"=" 'tolower($1) ~ /^secret/ {print $2}' $CFG)
AGENTID=$(awk -F"=" 'tolower($1) ~ /^agentid/ {print $2}' $CFG)
TOUSER=$(awk -F"=" 'tolower($1) ~ /^touser/ {print $2}' $CFG)
# 
# 支持发送的消息来自管道，例如 cat file|./wecaht_alert.sh
[ -z "$1" ] && CONTENT=($(< /dev/stdin)) || CONTENT=$1
[ -z "${CONTENT}" ] && echo "语法： $0 要发送的文本消息" && exit 0
[ -z "${AGENTID}" -o -z "${CORP_ID}" -o -z "${SECRET}" -o -z "${TOUSER}" ] && echo "配置文件错误，未找到相关配置项!" && exit 1
# 每个 Agent 的 Token 不一样
TOKEN_FILE=/tmp/.token.${AGENTID}

# 生成 Token
gen_token () {
	expire_time=0
	now=$(date +"%s")
	if [ -s ${TOKEN_FILE} ] ; then
		# Token 有效期固定为 7200s = 2小时,为安全设置100秒的提前过期
		expire_time=$(expr $(stat -c %Y ${TOKEN_FILE}) + 7100 )
	fi
	if [ ${now} -lt ${expire_time} ]; then
		echo "使用缓冲的 Token, 过期时间： $(date -d @$expire_time)"
		TOKEN=$(cat ${TOKEN_FILE})
		return
	fi
	# 已过期，生成新的 Token
	TOKEN=$(curl -s "$URL_GET_TOKEN?corpid=$CORP_ID&corpsecret=$SECRET"|jq -r .access_token)
	if [ -z ${TOKEN} ]; then
	    echo "Get token error, maybe network issue"
	    exit 100
	fi
	echo $TOKEN > ${TOKEN_FILE}
}


MSG='{'
#MSG=$MSG'"totag":"'$TOTAG'",'
MSG=$MSG'"touser":"'$TOUSER'",'
MSG=$MSG'"text":{"content":"'${CONTENT}'"},'
MSG=$MSG'"safe":"0",'
MSG=$MSG'"agentid":'$AGENTID','
MSG=$MSG'"msgtype":"text"'
MSG=$MSG'}'


gen_token

RET=$(curl -s -X POST -d "$MSG" ${URL_SEND_MSG}${TOKEN})

if [ -z "${RET}" ]; then
    echo "Send msg error, maybe network issue"
    exit 101
else
    errcode=$(echo ${RET} | jq -r .errcode)
    err_msg=$(echo ${RET} | jq -r .errmsg)
    if [ ${errcode} -ne 0 ]; then
        echo "Send msg error, with error $errcode: $err_msg"
        echo "原始发送消息： ${MSG}"
        exit 102
    else
        echo "OK"
    fi
fi
