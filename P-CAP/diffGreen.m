function [ ] = diffGreen(data_bs,bt_bs,et_bs,interval_bs,hd_bs,data_rs,bt_rs,et_rs,interval_rs,hd_rs,time_shift,green_folder,green_name,a,az_rover)

% difference opreation
% zhang chengfeng 2024 01 04
% apm wuhan

global mt count_loop az flag_nez;

%% g'

if flag_nez == 1
    data_bs = update_gb(data_bs,az,data_rs,az_rover);
end

%% a
rover_a = ones(1,9);
if count_loop > 1 && az_rover ~= -23
    rover_a = update_a(az_rover,mt);
end

for i = 1:9
    if rover_a(i) == 0
        if a(i) == 0
            a(i) = 1;
        else
            a(i) = 0;
        end
    else
        a(i) = a(i)/rover_a(i);
    end
end
% green_name
% a

fileID = fopen('/media/cfz/23z-5/gcap_inversion/fk4gcaprp/test4-matlab/a.txt','a');
fprintf(fileID, '%d    %f   %f  %f  %f  %f %f %f\n', count_loop, az_rover,a(7),a(4),a(1),a(9),a(6));
fprintf(fileID, '\n');
fclose(fileID);

for i = 1:size(data_bs,2)
    
    onedata_bs = data_bs(:,i);
    onebt_bs = bt_bs(i);
    oneet_bs = et_bs(i);
    oneinterval_bs = interval_bs(i);
    onehd_bs = hd_bs(:,i);
    onetime_bs = onebt_bs:oneinterval_bs:(oneet_bs+oneinterval_bs*1);
    
    onedata_rs = data_rs(:,i);
    onebt_rs = bt_rs(i);
    oneet_rs = et_rs(i);
    oneinterval_rs = interval_rs(i);
    onehd_rs = hd_rs(:,i);
    onetime_rs = onebt_rs:oneinterval_rs:(oneet_rs+oneinterval_rs*1);
    
    if abs(oneinterval_bs - oneinterval_rs) > 0
        fprintf('The interval is different !!!\n');
        continue;
    end
    
    for j = 1:size(time_shift,2)
        
        onetime_bs_ = onetime_bs + time_shift(j);
        
        bt = max(onebt_bs + time_shift(j),onebt_rs);
        et = min(oneet_bs + time_shift(j),oneet_rs);
        
        idx_bt_bs = find(abs(onetime_bs_ - bt) <= oneinterval_bs/2);
        idx_et_bs = find(abs(onetime_bs_ - et) <= oneinterval_bs/2);
        
        idx_bt_rs = find(abs(onetime_rs - bt) <= oneinterval_rs/2);
        idx_et_rs = find(abs(onetime_rs - et) <= oneinterval_rs/2);
        
        if length(onedata_rs(idx_bt_rs:idx_et_rs)) > length(onedata_bs(idx_bt_bs:idx_et_bs))
            idx_bt_rs = idx_bt_rs + 1;
        end
        
        if length(onedata_rs(idx_bt_rs:idx_et_rs)) < length(onedata_bs(idx_bt_bs:idx_et_bs))
            idx_bt_bs = idx_bt_bs + 1;
        end
        
        if length(onedata_rs(idx_bt_rs:idx_et_rs)) ~= length(onedata_bs(idx_bt_bs:idx_et_bs))
            fprintf(['Error at ' green_name num2str(i-1) ' when time shift = ' num2str(time_shift(j)) ' !!!\n']);
            continue;
        end
        
        diffG = onedata_rs(idx_bt_rs:idx_et_rs) - a(i)*onedata_bs(idx_bt_bs:idx_et_bs);
        hd = onehd_rs;
        hd(6) = bt;
        hd(7) = et;
        hd(80) = length(diffG);
        
        
        sacFile = [green_folder num2str(time_shift(j)) '/' green_name num2str(i-1)];
        
        wtSac(sacFile, hd, diffG);
        
        cf = 23;
        
    end
    
    cf = 23;
    
end


end

