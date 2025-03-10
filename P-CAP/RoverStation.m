function [] = RoverStation(onesubdir_bs,onesubdir_rs,time_shift,folder_output,a)

% read green function of rover stations and base station
% zhang chengfeng 2024 01 04
% apm wuhan

global rover_dist rover_az;

temps = split(onesubdir_bs(1).folder,'/');
for i = 1:size(time_shift,2)
    output_path = [folder_output '/' temps{end} '_' num2str(time_shift(i))];
    
    if ~exist(output_path,'dir')
        mkdir(output_path);
    end
end

[data_bs,bt_bs,et_bs,interval_bs,hd_bs] = rdBaseStation(onesubdir_bs);

for i = 1:size(onesubdir_rs,1)
    
    data_rs = [];
    bt_rs = [];
    et_rs = [];
    interval_rs = [];
    hd_rs = [];
    
    for j = 1:9
        
        sacFile = [onesubdir_rs(i).folder '/' onesubdir_rs(i).name(1:end-1) num2str(j-1)];
        [data, hd] = rdSac(sacFile);
        
        data_rs = [data_rs,data];
        bt_rs = [bt_rs,hd(6)];
        et_rs = [et_rs,hd(7)];
        interval_rs = [interval_rs,hd(1)];
        hd_rs = [hd_rs,hd];
        
    end
    
    target_dist = str2num(onesubdir_rs(i).name(1:end-6));
    az_rover = get_az(rover_dist,rover_az,target_dist);
    
    green_folder = [folder_output '/' temps{end} '_'];
    green_name = onesubdir_rs(i).name(1:end-1);
    diffGreen(data_bs,bt_bs,et_bs,interval_bs,hd_bs,data_rs,bt_rs,et_rs,interval_rs,hd_rs,time_shift,green_folder,green_name,a,az_rover);
    
    
    cf = 23;
    
end

fprintf([temps{end} ' done\n']);
fprintf(['\n']);

end

