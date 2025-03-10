function [] = w2cap_sh(par,work_folder,time_shift)

% write parameter to 7.cap.sh
% zhang chengfeng 2024 01 04
% apm wuhan

% par.depth_d0 = 5;    par.D_d1 = 2;      par.S_s1 = 5;       par.H_h1 = 1;    par.C_c1 = 0.01;   par.R_r1 = 0;
% par.depth_dd = 1;    par.D_d2 = 1;      par.S_s2 = 10;      par.W_w1 = 1;    par.C_c2 = 0.45;   par.R_r2 = 360;
% par.depth_d1 = 15;   par.D_d3 = 0.5;    par.S_s3 = 0;       par.X_x1 = 10;   par.C_c3 = 0.01;   par.R_r3 = 0;
%                                                                              par.C_c4 = 0.45;   par.R_r4 = 90;
% par.T_t1 = 40;       par.P_p1 = 0.015;  par.M_m1 = mname;   par.I_i1 = 1;                       par.R_r5 = -90;
% par.T_t2 = 80;       par.P_p2 = 50;     par.M_m2 = 6.4;     par.I_i2 = 0.1;  par.L_l1 = 3;      par.R_r6 = 90;

d0 = num2str(par.depth_d0);   D_d1 = num2str(par.D_d1);   S_s1 = num2str(par.S_s1);   H_h1 = num2str(par.H_h1);
d1 = num2str(par.depth_d1);   D_d2 = num2str(par.D_d2);   S_s2 = num2str(par.S_s2);   W_w1 = num2str(par.W_w1);
dd = num2str(par.depth_dd);   D_d3 = num2str(par.D_d3);   S_s3 = num2str(par.S_s3);   X_x1 = num2str(par.X_x1);

T_t1 = num2str(par.T_t1);     P_p1 = num2str(par.P_p1);   M_m1 = num2str(par.M_m1);   I_i1 = num2str(par.I_i1);
T_t2 = num2str(par.T_t2);     P_p2 = num2str(par.P_p2);   M_m2 = num2str(par.M_m2);   I_i2 = num2str(par.I_i2);

C_c1 = num2str(par.C_c1);     R_r1 = num2str(par.R_r1);   t0 = num2str(time_shift(1));
C_c2 = num2str(par.C_c2);     R_r2 = num2str(par.R_r2);   t1 = num2str(time_shift(end));
C_c3 = num2str(par.C_c3);     R_r3 = num2str(par.R_r3);   td = num2str(time_shift(2)-time_shift(1));
C_c4 = num2str(par.C_c4);     R_r4 = num2str(par.R_r4);
                              R_r5 = num2str(par.R_r5);
L_l1 = num2str(par.L_l1);     R_r6 = num2str(par.R_r6);
                              


str1 = ['for i in $(seq ' t0 ' ' td ' ' t1 ')'];
str2 = ['do'];
str3 = ['for j in $(seq ' d0 ' ' dd ' ' d1 ')'];
str4 = ['do'];
str5 = ['cap.pl -D' D_d1 '/' D_d2 '/' D_d3 ' -T' T_t1 '/' T_t2 '  -P' P_p1 '/' P_p2  '  -L' L_l1 '  -H' H_h1 '  -M' M_m1 '_${j}_${i}/' M_m2 ' -W' W_w1 ' -X' X_x1 ' -R' R_r1 '/' R_r2 '/' R_r3 '/' R_r4 '/' R_r5 '/' R_r6 '  -S' S_s1 '/' S_s2 '/' S_s3 ' -C' C_c1 '/' C_c2 '/' C_c3 '/' C_c4 ' -I' I_i1 '/' I_i2 ' -G./green -Zweight.dat data'];
str6 = ['done'];
str7 = ['done'];

if par.L_l1 <= 0
    str5 = ['cap.pl -D' D_d1 '/' D_d2 '/' D_d3 ' -T' T_t1 '/' T_t2 '  -P' P_p1 '/' P_p2 '  -H' H_h1 '  -M' M_m1 '_${j}_${i}/' M_m2 ' -W' W_w1 ' -X' X_x1 ' -R' R_r1 '/' R_r2 '/' R_r3 '/' R_r4 '/' R_r5 '/' R_r6 '  -S' S_s1 '/' S_s2 '/' S_s3 ' -C' C_c1 '/' C_c2 '/' C_c3 '/' C_c4 ' -I' I_i1 '/' I_i2 ' -G./green -Zweight.dat data'];
end

filename = [work_folder '/7.cap.sh'];
fileID = fopen(filename, 'w');
fprintf(fileID, '%s\n', str1);
fprintf(fileID, '%s\n', str2);
fprintf(fileID, '%s\n', str3);
fprintf(fileID, '%s\n', str4);
fprintf(fileID, '%s\n', str5);
fprintf(fileID, '%s\n', str6);
fprintf(fileID, '%s\n', str7);
fclose(fileID);


end

