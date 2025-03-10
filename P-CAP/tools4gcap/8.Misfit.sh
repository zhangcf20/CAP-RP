#!/bin/bash
cat data/*_*.out|grep ERR | gawk '{ gsub($2,""); print $0 }' | gawk '{gsub("_"," ");print $4,$5,$13,10,$7,$8,$9,$11,$5,$13,$11}' | sort -n -k2 > fit_error
ls data/*_*.out | sort -n -k 3 -t _ | awk '{print "cat",$1}' | sh | grep Variance | awk '{print $4}' > variance_reduction
paste variance_reduction fit_error | awk '{print $1,$2,$2,$6,$7,$8,$9,$1,$2,$3}' > use.txt
paste variance_reduction fit_error | awk '{print $2,$3,$1}' > xyz.txt

# cat data_inversion/dur2/BLCR_*.out | grep "rms" | awk -FBLCR_ '{print  $2}' | awk '{print $9,$1,$1,$3,$4,$5,$7,$1,$9}'>use.txt
gmt begin earthquake_depth jpg,eps
gmt set MAP_FRAME_TYPE plain
gmt set MAP_TICK_LENGTH_PRIMARY -0.1c
gmt set FONT_ANNOT_PRIMARY 13p,Helvetica,black  FONT_ANNOT_SECONDARY 13p,Helvetica,black
gmt set FONT_TITLE 15p,Helvetica,black FONT_LABEL 13p,Helvetica,black
gmt set MAP_FRAME_WIDTH 3p 
gmt set PS_MEDIA A4
#### axis ####
num=$(wc -l use.txt | awk '{ print $1}')
xmin0=$(cat use.txt | sort -gk 1 | head -1 | awk '{print $1}')
xmax0=$(cat use.txt | sort -gk 1 -r | head -1 | awk '{print $1}')
ymin0=$(cat use.txt | sort -gk 2 | head -1 | awk '{print $2}')
ymax0=$(cat use.txt | sort -gk 2 -r | head -1 | awk '{print $2}')
xmin=$(echo $xmin0 $xmax0 $num | awk '{print $1-($2-$1)/$3 - 2}')
xmax=$(echo $xmin0 $xmax0 $num | awk '{print $2+($2-$1)/$3 + 2}')
ymin=$(echo $ymin0 $ymax0 $num | awk '{print $1-($2-$1)/$3 - 2}')
ymax=$(echo $ymin0 $ymax0 $num | awk '{print $2+($2-$1)/$3 + 2}')
num1=$(echo $num | awk '{print $1-1}')
echo $xmin $xmax $ymin $ymax
J=X11c/-11c
R=$xmin/$xmax/$ymin/$ymax
gmt basemap -J$J -R$R -BWeSn -Bxa2f1+l"Variance reduction" -Bya2f1+l"Depth/km" 
cat use.txt | sort -gk 1 | head -$num1 | gmt meca -J$J -R$R -Sa0.5c  -M 
# #   深度  rms 深度 (km) strike dip rake 震级 newX newY ID
cat use.txt | sort -gk 1 -r| head -1 | gmt meca -J$J -R$R -Sa0.5c -Gred -M 
gmt end
