function [mt] = get_mt(work_folder,mname)

% get MomentTensor from the 'best' .out file 
% zhang chengfeng 2024 01 08
% apm wuhan


temp_cmd = sprintf('cd %s && cat use.txt | sort -gk 1 -r | head -1 | awk ''{print $9,$10}''',work_folder);
[status, cmd_output1] = system(temp_cmd);
cmd_output1 = checkcmdout(cmd_output1);
output_numbers1 = sscanf(cmd_output1, '%f');

outfile = [mname '_' num2str(output_numbers1(1,1)) '_' num2str(output_numbers1(2,1)) '.out'];

temp_cmd = sprintf('cd %s && cat data/%s | grep MomentTensor | awk ''{print $5,$6,$7,$8,$9,$10}''',work_folder,outfile);
[status, cmd_output2] = system(temp_cmd);
cmd_output2 = checkcmdout(cmd_output2);
output_numbers2 = sscanf(cmd_output2, '%f');

mt(1,1) = output_numbers2(1,1);
mt(1,2) = output_numbers2(2,1);
mt(1,3) = output_numbers2(3,1);
mt(2,2) = output_numbers2(4,1);
mt(2,3) = output_numbers2(5,1);
mt(3,3) = output_numbers2(6,1);

mt(2,1) = output_numbers2(2,1);
mt(3,1) = output_numbers2(3,1);
mt(3,2) = output_numbers2(5,1);

%fprintf(f_out,"# MomentTensor = %8.3e %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f\n",amp*1.0e13,mtensor[0][0],mtensor[0][1],mtensor[0][2],mtensor[1][1],mtensor[1][2],mtensor[2][2]);
  

end
