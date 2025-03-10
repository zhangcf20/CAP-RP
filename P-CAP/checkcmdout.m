function [variance] = checkcmdout(variance)

% check the output of cmd
% zhang chengfeng 2024 01 16
% apm wuhan


if contains(variance,'写入错误')
    temp = strsplit(variance,'写入错误');
    variance = temp{1,2};
end


end

