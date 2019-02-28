#!/usr/bin/env bash
#=====================================================================================#
#   System Required:  CentOS, Debian, Ubuntu                                          #
#   Description: Check ShadowsockR Server is running or not                           #
#   Author: ComeBey for hasan w                                                       #
#   Visit: https://www.youtube.com/channel/UCiMTLB5vELIq3Dz9muBRfJw?view_as=subscriber#
#=====================================================================================#

name=(ShadowsockR ShadowsockR-Python ShadowsocksR ShadowsockR-Go ShadowsockR-libev)
path=/var/log
[[ ! -d ${path} ]] && mkdir -p ${path}
log=${path}/shadowsocksR-crond.log

shadowsockR_init[0]=/etc/init.d/shadowsockR
shadowsockR_init[1]=/etc/init.d/shadowsockR-python
shadowsockR_init[2]=/etc/init.d/shadowsockR-r
shadowsockR_init[3]=/etc/init.d/shadowsockR-go
shadowsockR_init[4]=/etc/init.d/shadowsockR-libev

i=0
for init in "${shadowsockR_init[@]}"; do
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
