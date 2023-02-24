#!/usr/bin/bash

lvm_check=0


sum1=$(df -Bg | grep "^/dev/" | grep -v "/boot$" | awk '{sumG += $2} END {print sumG}')
sum2=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{sumM += $3} END {print sumM}')
pct=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{sumM += $3} {sumG += $2} END {printf("%d"), sumM/sumG*100}')

[[ $(lsblk | grep "lvm") ]] && lvm_check="yes" || lvm_check="no"

echo "#Architecture    :	$(uname -a)"
echo "#CPU physical    :	$(grep "physical id" /proc/cpuinfo | wc -l)"
echo "#vCPU            :	$(grep "processor" /proc/cpuinfo | wc -l)"
echo "#Memory Usage    :	$(free --mega | awk 'FNR == 2 {printf "%d/%dMB (%.2f%%)", $3, $7, $3 / $7 * 100.0}')"
echo "#Disk Usage      :	$sum2/${sum1}Gb ($pct%)"
echo "#CPU load        :	$(top -bn1 | grep "^%Cpu" | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')"
echo "#Last boot       :	$(who -b | awk '{print $3,$4}')"
echo "#LVM use         :	$lvm_check"
echo "#Connections TCP :	$(ss | grep tcp | wc -l) ESTABLISHED"
echo "#User log        :	$(users | wc -w)"
echo "#Network         :	IP $(hostname -I) ($(ip link | awk 'FNR == 4 {print $2}'))"
echo "#Sudo            :	$(journalctl -q _COMM=sudo | grep "COMMAND" | wc -l) cmd"