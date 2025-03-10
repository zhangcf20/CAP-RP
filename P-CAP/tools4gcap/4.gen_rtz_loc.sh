#*************************************************************************
#****4.The fouth step in gcap*********************************************
#****This scrips rotates the sac and mul 100******************************
#****still in groundVel directory and then `sh gen_rtz_loc.sh`************
#****SMH,WHIGG,2017.11.07*************************************************
#*************************************************************************

if [ -d rtr_mul_100 ]; then
 echo " skipping to transfer "
else
 mkdir rtr_mul_100
fi
saclst dist f *.BHZ | awk 'BEGIN {print "cut O 0 300"}$2<800 {a=$1;print "r "$1 ;print "rtr" ;print "mul 100"; gsub("BHZ","z",a);print "w rtr_mul_100/"a ;a=$1; b=$1; gsub("BHZ", "BHE",a); gsub("BHZ","BHN", b);print "r",a,b; print "rtr" ; print "mul 100"; print "rot to gcp"; gsub("BHE","r",a); gsub("BHN","t",b);print "w rtr_mul_100/"a, "rtr_mul_100/"b;} END {print "quit"}' | sac

saclst dist f *.BHZ | awk 'BEGIN {print "cut O 0 300"}$2<800 {a=$1;print "r "$1 ;print "rtr" ;print "mul 100"; gsub("BHZ","z",a);print "w rtr_mul_100/"a ;a=$1; b=$1; gsub("BHZ", "BH2",a); gsub("BHZ","BH1", b);print "r",a,b; print "rtr" ; print "mul 100"; print "rot to gcp"; gsub("BH2","r",a); gsub("BH1","t",b);print "w rtr_mul_100/"a, "rtr_mul_100/"b;} END {print "quit"}' | sac
