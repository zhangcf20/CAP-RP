function [] = gnss_data(mpath,data_folder,green_folder,predata_folder1,info,dist)

% ENZ 2 RTZ
copyfile([pwd '/tools4gcap/4.gen_rtz_loc.sh'],predata_folder1);
temp_cmd = sprintf('cd %s && bash 4.gen_rtz_loc.sh',predata_folder1);
system(temp_cmd);

% move RTZ data 2 data_folder
src_folder = [predata_folder1 '/rtr_mul_100'];
movefile(fullfile(src_folder, '*'), data_folder);

% generate weight file, and generate cmd of green function with fk
flag_wave = '0 0 0 1 1';
copyfile([pwd '/tools4gcap/5.genWeight.sh'],data_folder);
w2genWeight_sh(flag_wave,data_folder);
temp_cmd = sprintf('cd %s && bash 5.genWeight.sh',data_folder);
system(temp_cmd);


copyfile([pwd '/tools4gcap/6.genfk.sh'],data_folder);
w2genfk_sh(info,data_folder);
temp_cmd = sprintf('cd %s && bash 6.genfk.sh > getgreen_fk.sh',data_folder);
system(temp_cmd);

% gnenrate rover stations' green function with fk.pl
green_folder_rover = [green_folder '/rover_station'];
mkdir(green_folder_rover);
movefile([data_folder '/getgreen_fk.sh'],green_folder_rover);
copyfile(mpath,green_folder_rover);
temp_cmd = sprintf('cd %s && bash getgreen_fk.sh',green_folder_rover);
system(temp_cmd);

% gnenrate base station's green function with fk.pl
green_folder_base = [green_folder '/base_station'];
mkdir(green_folder_base);
copyfile([green_folder_rover '/getgreen_fk.sh'],green_folder_base);
copyfile(mpath,green_folder_base);
dist_max = w2getgreen_fk_sh_bs(floor(dist),info,green_folder_base);
temp_cmd = sprintf('cd %s && bash getgreen_fk.sh',green_folder_base);
system(temp_cmd);
deletedm(green_folder_base,dist_max);


end

