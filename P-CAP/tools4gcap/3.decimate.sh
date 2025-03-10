#*************************************************************************
#****3.The third step in gcap*********************************************
#****This scrips decimates the sac data to 1 Hz***************************
#****`cd groundVel` and then `sh decimate.sh`*****************************
#****SMH,WHIGG,2017.11.07*************************************************
#*************************************************************************

saclst delta f *.*.*.* | awk '{if($2==0.04){print "r",$1;print "stretch 2";print "stretch 2";print "decimate 5";print "w over"}if($2==0.1){print "r",$1;print "stretch 2";print "w over";} if($2==0.02){print "r",$1;print "stretch 2";print "decimate 5";print "w over";}if($2==0.03){print "r",$1;print "stretch 3";print "decimate 5";print "w over";} if($2>=0.025 && $2<0.02501){print "r",$1;print "decimate 2";print "w over"}if($2==0.01){print "r",$1;print "decimate 5";print "w over";}if($2==0.005){ print "r",$1;print"decimate 2";print "decimate 5";print "w over";}} END{print "quit"}' | sac

saclst delta f *.*.*.* | awk '{if($2==0.05){print "r",$1;print "decimate 5";print "decimate 2";print "decimate 2";print "w over";}} END{print "quit"}' | sac
