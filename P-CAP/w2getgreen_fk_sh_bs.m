function [dist_max] = w2getgreen_fk_sh_bs(dist,info,green_folder_base)

% get green function of base staton
% zhang chengfeng 2024 01 04
% apm wuhan

dsam = 1;

d0 = info.depth_d0;
d1 = info.depth_d1;
dd = info.depth_dd;

model = info.M;
np = num2str(info.np);
sampling = num2str(info.sam/dsam);

fileID = fopen([green_folder_base '/getgreen_fk.sh'], 'r');
firstLine = fgetl(fileID);
fclose(fileID);
temp = strsplit(firstLine,' ');
dist_max = temp{1,end-1};

filename = [green_folder_base '/getgreen_fk.sh'];
fileID = fopen(filename, 'w');
for i = d0:dd:d1
    str = ['fk.pl -M' model '/' num2str(i) ' -N' np '/' sampling ' -S2 ' num2str(round(dist)) ' ' dist_max];
    fprintf(fileID, '%s\n', str);
end
fclose(fileID);

cf = 23;

end

