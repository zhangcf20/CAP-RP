clear;clc;close all;
%%
latlon_eq = [35.69,-117.54];
latlon_bs = [35.07,-117.57];

global az flag_nez;

[az,dist] = calculate_A_D(latlon_eq(1,2),latlon_eq(1,1),latlon_bs(1,2),latlon_bs(1,1));
[baz,ddist] = calculate_A_D(latlon_bs(1,2),latlon_bs(1,1),latlon_eq(1,2),latlon_eq(1,1));

flag_nez = 1;
%% make dir (*.ENZ data should be prepared first under the 'predata')

work_folder = '/media/cfz/23z-5/gcap_inversion/updated/rid6.4';
mpath = '/media/cfz/23z-5/seismictool/gcap_rp/tools4gcap/RID';   % velocity_model_path
mname = 'RID';   % velocity_model_name

data_folder = [work_folder '/data'];
green_folder = [work_folder '/green'];
predata_folder = [work_folder '/predata'];
mkdir(data_folder);
mkdir(green_folder);

%% pretreatment (convert data to RTZ, and generate green function with fk)

% ENZ 2 RTZ
copyfile([pwd '/tools4gcap/4.gen_rtz_loc.sh'],predata_folder);
temp_cmd = sprintf('cd %s && bash 4.gen_rtz_loc.sh',predata_folder);
system(temp_cmd);

% move RTZ data 2 data_folder
src_folder = [predata_folder '/rtr_mul_100'];
movefile(fullfile(src_folder, '*'), data_folder);

% generate weight file, and generate cmd of green function with fk
flag_wave = '0 0 0 1 1';
copyfile([pwd '/tools4gcap/5.genWeight.sh'],data_folder);
w2genWeight_sh(flag_wave,data_folder);
temp_cmd = sprintf('cd %s && bash 5.genWeight.sh',data_folder);
system(temp_cmd);

info.depth_d0 = 5;    info.M = mname;
info.depth_dd = 1;    info.np = 1024;
info.depth_d1 = 15;   info.sam = 1;
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

%% loop gcap 2 obtain stable source parameters

par.depth_d0 = 5;    par.D_d1 = 2;      par.S_s1 = 5;       par.H_h1 = 1;    par.C_c1 = 0.01;   par.R_r1 = 0;
par.depth_dd = 1;    par.D_d2 = 1;      par.S_s2 = 10;      par.W_w1 = 2;    par.C_c2 = 0.08;   par.R_r2 = 360;
par.depth_d1 = 15;   par.D_d3 = 0.5;    par.S_s3 = 0;       par.X_x1 = 10;   par.C_c3 = 0.02;   par.R_r3 = 0;
                                                                             par.C_c4 = 0.08;   par.R_r4 = 90;
par.T_t1 = 40;       par.P_p1 = 0.05;   par.M_m1 = mname;   par.I_i1 = 5;                       par.R_r5 = -90;
par.T_t2 = 100;      par.P_p2 = 50;     par.M_m2 = 6.4;     par.I_i2 = 0.1;  par.L_l1 = -1;     par.R_r6 = 90;

global mt count_loop rover_dist rover_az;
[rover_mrk,rover_dist,rover_az] = textread([data_folder '/marklst.txt'],'%s %d %d');

base_a = ones(1,9);

variance_reduction = [];

time_shift = -5:1:5;

green_folder_diff = [green_folder '/' mname];

for count_loop = 1:3
    
    
    if count_loop > 1
        mt = get_mt(work_folder,mname);
        base_a = update_a(az,mt);
    end
    
    getdiffgreen(base_a,time_shift,green_folder_base,green_folder_rover,green_folder_diff);
   
    copyfile([pwd '/tools4gcap/7.cap.sh'],work_folder);
    copyfile([pwd '/tools4gcap/8.Misfit.sh'],work_folder);
    w2cap_sh(par,work_folder,time_shift);
    temp_cmd = sprintf('cd %s && bash 7.cap.sh',work_folder);
    system(temp_cmd);
    temp_cmd = sprintf('cd %s && bash 8.Misfit.sh',work_folder);
    system(temp_cmd);
    
    temp_cmd = sprintf('cd %s && cat use.txt | sort -gk 1 -r | head -1 | awk ''{print $1,$4,$5,$6,$2,$7 }''',work_folder);
    [status, variance] = system(temp_cmd);
    variance = checkcmdout(variance);
    variance_reduction(:,count_loop) = sscanf(variance, '%f');
    
    cf = 23;
    
end


%% 
filepath = [work_folder '/variance_info.txt'];
dlmwrite(filepath, variance_reduction', 'delimiter', '\t'); 

close all;
figure;plot(1:count_loop,variance_reduction(1,:),'-.');hold on;plot(1:count_loop,variance_reduction(1,:),'^');
xlabel('Index of loop'); ylabel('Variance reduction');grid on;set(gca,'FontName','Times New Roman','FontSize',16,'LineWidth',1);





