function [] = movegreen_seis(mname,green_folder,par,time_shift)

fprintf('moving green function\n');

for i = par.depth_d0 : par.depth_dd :par.depth_d1
    for j = 1:size(time_shift,2)
       green_path_gnss = [green_folder '/' mname '/' mname '_' num2str(i) '_' num2str(time_shift(j))];
       green_path_seis = [green_folder '/seis_station' '/' mname '_' num2str(i)];
       
       subdir = dir([green_path_seis '/*.grn*']);
       for k = 1:size(subdir,1)
          copyfile([green_path_seis '/' subdir(k).name],green_path_gnss); 
          
          cf = 23;
       end
    end
    
end

