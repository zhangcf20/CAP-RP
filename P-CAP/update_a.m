function [a] = update_a(rover_az,mt)

% horizontal radiation coefficients from a moment-tensor mt
% zhang chengfeng 2024 01 08
% apm wuhan


a = [];

for i = 1:size(rover_az,1)
    
    az = rover_az(i)*pi/180;
    saz = sin(az);       caz = cos(az);
    saz2 = 2*saz*caz;    caz2 = caz*caz-saz*saz;
    
    a1 = -0.5*(mt(1,1)-mt(2,2))*caz2 - mt(1,2)*saz2;
    a2 = -mt(1,3)*caz - mt(2,3)*saz;
    a3 = (2*mt(3,3)-mt(2,2)-mt(1,1))/6;
    a4 = -0.5*(mt(1,1)-mt(2,2))*saz2 + mt(1,2)*caz2;
    a5 = -mt(1,3)*saz + mt(2,3)*caz;
    
    a = [a3,a3,0,a2,a2,a5,a1,a1,a4];
    
    
end



% /*****************************************************************
%  horizontal radiation coefficients from a moment-tensor m
%    see Jost and Herrmann, 1989 (note an error in Eq A5.4-A5.6)
% *****************************************************************/
% void	mt_radiat(float az, float m[3][3], float rad[4][3]) {
%    float saz, caz, saz2, caz2;
%    az *= DEG2RAD;
%    saz = sin(az); caz = cos(az);
%    saz2 = 2*saz*caz; caz2 = caz*caz-saz*saz;
%    rad[2][0] = rad[2][1] = -0.5*(m[0][0]-m[1][1])*caz2 - m[0][1]*saz2;
%    rad[1][0] = rad[1][1] = -m[0][2]*caz - m[1][2]*saz;
%    rad[0][0] = rad[0][1] =  (2*m[2][2]-m[0][0]-m[1][1])/6.;
%    rad[2][2] = -0.5*(m[0][0]-m[1][1])*saz2 + m[0][1]*caz2;
%    rad[1][2] = -m[0][2]*saz + m[1][2]*caz;
%    rad[0][2] = 0.;
%    /* contribution from explosion: */
%    rad[3][0] = rad[3][1] = (m[0][0]+m[1][1]+m[2][2])/3.;
%    rad[3][2] = 0;
% }

end

