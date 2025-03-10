/origin/ {x=$5; 
 split(x,aa,",");
 split(aa[3],bb,":");
 split(bb[3],cc,".");
 print "r $1$";
 print "chnhdr o gmt ",aa[1],aa[2],bb[1],bb[2],cc[1],substr(cc[2],1,3);
 print "evaluate to tt1 &1,o * -1";
 print "chnhdr allt %tt1%";
}
/latitude/ {print "ch evla",$4}
/longitude/ {print "ch evlo",$4}
/depth/ {print "ch evdp",$5}

END{
 print "w over";
}