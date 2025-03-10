function [] = w2genWeight_sh(flag_wave,data_folder)

% write flags of pnl V   pnl R   Vertical   Radial   Tang   to  5.genWeight.sh
% zhang chengfeng 2024 01 04
% apm wuhan

str1 = ['saclst dist t1 f *.z   | awk ''{gsub(".z","",$1); printf "%s %d %s %.1f %s\n", $1,$2,"' flag_wave '",$3,"0"}'' | sort -n --key=2 > weight.dat'];
str2 = ['cat weight.dat | awk ''{print "saclst az dist f",$1".z"}'' | sh | sort -n -k 2 | awk ''{printf "%s %d ' flag_wave ' -12345.0 0\n",$1,$3}'' | sed s/.z//g > weight_az.dat'];

filename = [data_folder '/5.genWeight.sh'];
fileID = fopen(filename, 'w');
fprintf(fileID, '%s\n', str1);
fprintf(fileID, '%s\n', str2);
fclose(fileID);


end

