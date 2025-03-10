function [] = seismograph_data(mpath,data_folder,green_folder,predata_folder2,info)


% ENZ 2 RTZ
copyfile([pwd '/tools4gcap/4.gen_rtz_loc.sh'],predata_folder2);
temp_cmd = sprintf('cd %s && bash 4.gen_rtz_loc.sh',predata_folder2);
system(temp_cmd);

% move RTZ data 2 data_folder
src_folder = [predata_folder2 '/rtr_mul_100'];

% generate weight file, and generate cmd of green function with fk
flag_wave = '1 1 1 1 1';
copyfile([pwd '/tools4gcap/5.genWeight.sh'],src_folder);
w2genWeight_sh(flag_wave,src_folder);
temp_cmd = sprintf('cd %s && bash 5.genWeight.sh',src_folder);
system(temp_cmd);

copyfile([pwd '/tools4gcap/6.genfk.sh'],src_folder);
w2genfk_sh(info,src_folder);
temp_cmd = sprintf('cd %s && bash 6.genfk.sh > getgreen_fk.sh',src_folder);
system(temp_cmd);

% read weight of gnss and seis
[markname1,dist1,pv1,pr1,sv1,sr1,st1,f11,f21] = textread([src_folder '/weight.dat'],'%s%d%d%d%d%d%d%f%d');
[markname2,dist2,pv2,pr2,sv2,sr2,st2,f12,f22] = textread([data_folder '/weight.dat'],'%s%d%d%d%d%d%d%f%d');

markname = [markname1;markname2];
dist = [dist1;dist2];
pv = [pv1;pv2];
pr = [pr1;pr2];
sv = [sv1;sv2];
sr = [sr1;sr2];
st = [st1;st2];
f1 = [f11;f12];
f2 = [f21;f22];

fid = fopen([data_folder '/weight.dat'], 'w');
for i = 1:size(markname, 1)
    fprintf(fid, '%s %d %d %d %d %d %d %.1f %d\n', markname{i,:},dist(i),pv(i),pr(i),sv(i),sr(i),st(i),f1(i),f2(i));
end
fclose(fid);

movefile(fullfile(src_folder, '*.r'), data_folder);
movefile(fullfile(src_folder, '*.t'), data_folder);
movefile(fullfile(src_folder, '*.z'), data_folder);


% gnenrate rover stations' green function with fk.pl
green_folder_seis = [green_folder '/seis_station'];
mkdir(green_folder_seis);
movefile([src_folder '/getgreen_fk.sh'],green_folder_seis);
copyfile(mpath,green_folder_seis);
temp_cmd = sprintf('cd %s && bash getgreen_fk.sh',green_folder_seis);
system(temp_cmd);


end

