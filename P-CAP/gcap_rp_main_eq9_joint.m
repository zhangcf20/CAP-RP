clear;clc;close all;
%%
latlon_eq = [35.69,-117.54];
latlon_bs = [35.07,-117.57];

global az flag_nez;

[az,dist] = calculate_A_D(latlon_eq(1,2),latlon_eq(1,1),latlon_bs(1,2),latlon_bs(1,1));
[baz,ddist] = calculate_A_D(latlon_bs(1,2),latlon_bs(1,1),latlon_eq(1,2),latlon_eq(1,1));

flag_nez = 1;
%% make dir (*.ENZ data should be prepared first under the 'predata')

work_folder = '/media/cfz/23z-5/gcap_inversion/updated/rid6.4-joint';
mpath = '/media/cfz/23z-5/seismictool/gcap_rp/tools4gcap';   % velocity_model_path
mname = 'RID';   % velocity_model_name

data_folder = [work_folder '/data'];
green_folder = [work_folder '/green'];
predata_folder1 = [work_folder '/predata/gnss'];
predata_folder2 = [work_folder '/predata/seis'];
green_folder_rover = [green_folder '/rover_station'];
green_folder_base = [green_folder '/base_station'];

if exist(data_folder, 'dir') == 7    [status, message, messageid]=rmdir(data_folder, 's');   end
if exist(green_folder, 'dir') == 7   [status, message, messageid]=rmdir(green_folder, 's');  end
mkdir(data_folder);
mkdir(green_folder);

%% pretreatment (convert data to RTZ, and generate green function with fk)


info.depth_d0 = 5;    info.M = mname;
info.depth_dd = 1;    info.np = 1024;
info.depth_d1 = 15;   info.sam = 1;

%       gnss         %
gnss_data([mpath '/' mname],data_folder,green_folder,predata_folder1,info,dist);

%    seismograph     %
seismograph_data([mpath '/' mname],data_folder,green_folder,predata_folder2,info);

%% loop gcap 2 obtain stable source parameters

par.depth_d0 = 5;    par.D_d1 = 2;      par.S_s1 = 5;       par.H_h1 = 1;    par.C_c1 = 0.02;   par.R_r1 = 0;
par.depth_dd = 1;    par.D_d2 = 1;      par.S_s2 = 10;      par.W_w1 = 2;    par.C_c2 = 0.10;   par.R_r2 = 360;
par.depth_d1 = 15;   par.D_d3 = 0.5;    par.S_s3 = 0;       par.X_x1 = 10;   par.C_c3 = 0.02;   par.R_r3 = 0;
                                                                             par.C_c4 = 0.08;   par.R_r4 = 90;
par.T_t1 = 60;       par.P_p1 = 0.05;   par.M_m1 = mname;   par.I_i1 = 5;                       par.R_r5 = -90;
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
    movegreen_seis(mname,green_folder,par,time_shift);
   
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





