function [data_bs,bt_bs,et_bs,interval_bs,hd_bs] = rdBaseStation(onesubdir_bs)

% read green function of base station
% zhang chengfeng 2024 01 04
% apm wuhan

data_bs = [];
bt_bs = [];
et_bs = [];
interval_bs = [];
hd_bs = [];

for i = 1:size(onesubdir_bs,1)
    
    sacFile = [onesubdir_bs(i).folder '/' onesubdir_bs(i).name];
    [data, hd] = rdSac(sacFile);
    
    data_bs = [data_bs,data];
    bt_bs = [bt_bs,hd(6)];
    et_bs = [et_bs,hd(7)];
    interval_bs = [interval_bs,hd(1)];
    hd_bs = [hd_bs,hd];
    
    cf = 23;
    
end


end

