function [data_bs_update] = update_gb(data_bs,az_base,data_rs,az_rover)

% g'b = Tm * T'b * gb 
% zhang chengfeng 2025 03 04
% apm wuhan

TORAD = 3.1415926/180;

data_bs_update = data_bs;

% az_base = 10;az_rover = 300;TORAD = 3.1415926/180;
% 
% Tm = [cos(az_rover*TORAD),sin(az_rover*TORAD),0;-sin(az_rover*TORAD),cos(az_rover*TORAD),0;0,0,1];
% Tbb = [cos(-az_base*TORAD),sin(-az_base*TORAD),0;-sin(-az_base*TORAD),cos(-az_base*TORAD),0;0,0,1];
% 
% T = Tm*Tbb;
% 
% tt=[cos(az_rover*TORAD)*cos(az_base*TORAD)+sin(az_rover*TORAD)*sin(az_base*TORAD),-cos(az_rover*TORAD)*sin(az_base*TORAD)+sin(az_rover*TORAD)*cos(az_base*TORAD),0;
%    -sin(az_rover*TORAD)*cos(az_base*TORAD)+cos(az_rover*TORAD)*sin(az_base*TORAD),sin(az_rover*TORAD)*sin(az_base*TORAD)+cos(az_rover*TORAD)*cos(az_base*TORAD),0;0,0,1];

t1 =  cos(az_rover*TORAD)*cos(az_base*TORAD)+sin(az_rover*TORAD)*sin(az_base*TORAD);
t2 = -cos(az_rover*TORAD)*sin(az_base*TORAD)+sin(az_rover*TORAD)*cos(az_base*TORAD);
t3 = -sin(az_rover*TORAD)*cos(az_base*TORAD)+cos(az_rover*TORAD)*sin(az_base*TORAD);
t4 =  sin(az_rover*TORAD)*sin(az_base*TORAD)+cos(az_rover*TORAD)*cos(az_base*TORAD);

for i = 1:size(data_bs,1)
    
    data_bs_update(i,8) = t1*data_bs(i,8) + t2*data_bs(i,7); %g7
    data_bs_update(i,5) = t1*data_bs(i,5) + t2*data_bs(i,4); %g4
    data_bs_update(i,2) = t1*data_bs(i,2) + t2*data_bs(i,1); %g1
    
    data_bs_update(i,7) = t3*data_bs(i,8) + t4*data_bs(i,7); %g6
    data_bs_update(i,4) = t3*data_bs(i,5) + t4*data_bs(i,4); %g3
    data_bs_update(i,1) = t3*data_bs(i,2) + t4*data_bs(i,1); %g0
    
    
end


cf = 23;



end

