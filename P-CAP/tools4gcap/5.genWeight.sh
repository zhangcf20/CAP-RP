#*************************************************************************
#****5.The fifth step in gcap*********************************************
#****This scrips generates Weight.dat file********************************
#****in groundVel/rtr_mul_100 directory and then `sh genWeight.sh`********
#****after those pocesses, copy the dir rtr_mul_100 out and name as data**
#****SMH,WHIGG,2017.11.07*************************************************
#*************************************************************************

saclst dist t1 f *.z   | awk '{gsub(".z","",$1); printf "%s %d %s %.1f %s\n", $1,$2,"1 1 1 1 1",$3,"0"}' | sort -n --key=2 > weight.dat

cat weight.dat | awk '{print "saclst az dist f",$1".z"}' | sh | sort -n -k 2 | awk '{printf "%s %d 1 1 1 1 1 -12345.0 0\n",$1,$3}' | sed s/.z//g > weight_az.dat