function [] = getdiffgreen(a,time_shift,green_folder_base,green_folder_rover,green_folder_diff)

% difference of green function between rover stations and base station
% zhang chengfeng 2024 01 04
% apm wuhan


subdir_bs = dir(green_folder_base);
subdir_rs = dir(green_folder_rover);

depth_all = [];
mname = ' ';

for i = 1:size(subdir_rs,1)
    
    temps = split(subdir_rs(i).name,'_');
    
    if str2num(temps{end}) > 0
        target_depth = subdir_rs(i).name;
    else
        continue;
    end
    
    onesubdir_rs = dir([green_folder_rover '/' target_depth '/*grn.0']);
    
    for j = 1:size(subdir_bs,1)
        if contains(subdir_bs(j).name,target_depth)
            onesubdir_bs = dir([green_folder_base '/' target_depth '/*grn*']);
            break;
        end
    end
    
    depth_all = [depth_all;str2num(temps{end})];
    mname = temps{1};
    
    RoverStation(onesubdir_bs,onesubdir_rs,time_shift,green_folder_diff,a);
    
    cf = 23;
    
end


% decimate_diff(green_folder_diff,depth_all,time_shift,mname);


fprintf('difference process done\n');




end

