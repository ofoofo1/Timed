#!/usr/bin/env bash
#=====================================================================================#
#   System Required:  CentOS, Debian, Ubuntu                                          #
#   Description: Check ShadowsocksR Server is running or not                           #
#   Author: ComeBey for hasan w                                                       #
#   Visit: https://www.youtube.com/channel/UCiMTLB5vELIq3Dz9muBRfJw?view_as=subscriber#
#=====================================================================================#

name=(shadowsocksr shadowsocksr-Python ShadowsocksR ShadowsocksR-Go ShadowsocksR-libev)
path=/var/log
[[ ! -d ${path} ]] && mkdir -p ${path}
log=${path}/shadowsocksr-crond.log

shadowsocksr_init[0]=/etc/init.d/shadowsocksr
shadowsocksr_init[1]=/etc/init.d/shadowsocksr-python
shadowsocksr_init[2]=/etc/init.d/shadowsocksr-r
shadowsocksr_init[3]=/etc/init.d/shadowsocksr-go
shadowsocksr_init[4]=/etc/init.d/shadowsocksr-libev

i=0
for init in "${shadowsocksr_init[@]}"; do
    pid=""
    if [ -f ${init} ]; then
        ss_status=$(${init} status)
        if [ $? -eq 0 ]; then
            pid=$(echo "$ss_status" | sed -e 's/[^0-9]*//g')
        fi

        if [ -z "${pid}" ]; then
            echo "$(date +'%Y-%m-%d %H:%M:%S') ${name[$i]} is not running" >> ${log}
            echo "$(date +'%Y-%m-%d %H:%M:%S') Starting ${name[$i]}" >> ${log}
            ${init} start &>/dev/null
            if [ $? -eq 0 ]; then
                echo "$(date +'%Y-%m-%d %H:%M:%S') ${name[$i]} start success" >> ${log}
            else
                echo "$(date +'%Y-%m-%d %H:%M:%S') ${name[$i]} start failed" >> ${log}
            fi
        else
            echo "$(date +'%Y-%m-%d %H:%M:%S') ${name[$i]} is running with pid $pid" >> ${log}
        fi
    
    fi
    ((i++))
done
