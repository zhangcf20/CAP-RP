function [az] = get_az(rover_dis,rover_az,target_dist)

% get az of rover station
% zhang chengfeng 2024 01 09
% apm wuhan


az = -23;

for i = 1:size(rover_dis,1)
    if rover_dis(i) == target_dist
        az = rover_az(i);
        break;
    end
end



end

