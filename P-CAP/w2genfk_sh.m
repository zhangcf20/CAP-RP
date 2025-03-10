function [] = w2genfk_sh(info,data_folder)

% write green function info to 6.genfk.sh
% zhang chengfeng 2024 01 04
% apm wuhan

%info.depth_d0 = 2;    info.M = 'RID';
%info.depth_dd = 1;    info.np = 2048;
%info.depth_d1 = 20;   info.sam = 1;

d0 = num2str(info.depth_d0);
d1 = num2str(info.depth_d1);
dd = num2str(info.depth_dd);

model = info.M;
np = num2str(info.np);
sampling = num2str(info.sam);


str1 = ['distlst=`saclst dist f *.z | awk ''{printf "%d\n",$2}'' | sort -n | uniq | gawk ''$1<800{printf "%d ",$1} END {printf "\n"}''`'];
str2 = ['awk -v dist="$distlst" ''BEGIN {for (dep=' d0 ';dep<=' d1 ';dep+=' dd ') { print "fk.pl  -M' model '/"dep," -N' np '/' sampling ' -S2 " dist} }'''];

str3 = ['distlst=`saclst dist f *.z | awk ''{printf "%d\n",$2}''`'];
str4 = ['azlst=`saclst az f *.z | awk ''{printf "%d\n",$2}''`'];
str5 = ['namelst=`saclst az f *.z | awk ''{printf "%.4s\n",$1}''`'];
str6 = ['paste <(printf "%s\n" "$namelst") <(printf "%s\n" "$distlst") <(printf "%s\n" "$azlst") > marklst.txt'];


filename = [data_folder '/6.genfk.sh'];
fileID = fopen(filename, 'w');
fprintf(fileID, '%s\n', str1);
fprintf(fileID, '%s\n', str2);
fprintf(fileID, '%s\n', str3);
fprintf(fileID, '%s\n', str4);
fprintf(fileID, '%s\n', str5);
fprintf(fileID, '%s\n', str6);
fclose(fileID);

end

