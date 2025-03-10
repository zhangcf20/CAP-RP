saclst delta f *.*.* | awk '{if($2==0.1){print "r",$1;print "decimate 5";print "decimate 2";print "w over";}} END{print "quit"}' | sac
