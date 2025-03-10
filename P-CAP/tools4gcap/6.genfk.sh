#*************************************************************************
#****6.The sixth step in gcap*********************************************
#****This scrips generates a script for calculating Green's function******
#****in data directory (in fifth step) and then `sh genfk.sh > runfk.sh`**
#****SMH,WHIGG,2017.11.07*************************************************
#*************************************************************************

distlst=`saclst dist f *.z | awk '{printf "%d\n",$2}' | sort -n | uniq | gawk '$1<800{printf "%d ",$1} END {printf "\n"}'`

# 计算双力偶
awk -v dist="$distlst" 'BEGIN {for (dep=2;dep<20;dep+=1) { print "fk.pl  -MRID/"dep," -N2048/1 -S2 " dist} }'

# 计算爆炸源
#awk -v dist="$distlst" 'BEGIN {for (dep=0.5;dep<3;dep+=1) { print "fk.pl  -Mrchdis/"dep," -N2048/0.05 -S0 " dist} }'
