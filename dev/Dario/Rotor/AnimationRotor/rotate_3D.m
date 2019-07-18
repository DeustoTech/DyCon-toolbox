function R = rotate_3D(V, mode, theta, u)
% Function to compute the rotation of a vector in a 3D space.
%
% Copyright and support
% (c) Nicolas Douillet 2018, nicolas.douillet (at) free.fr
%
%%% Syntax
% R = rotate_3D(V, mode, theta, u)
%
%%% Description
% R = rotate_3D(V, mode, theta, u) computes the vector R, which results
% from the rotation of V vector around u vector and of theta angle.
%
%% Input arguments %%
%
%       [-Vx-]
% - V : [-Vy-] numeric -array of- vector(s), the vector(s) to rotate. 
%       [-Vz-]
%
% - mode : string  {'x', 'X', 'y', 'Y', 'z', 'Z', 'any', 'ANY'} 
%
% - theta : numeric scalar, the rotation angle (default unit is radian).
%
%                 [ux]
% - u : unicolumn [uy] numeric vector, the rotation axis. Not taken into
%                 [uz]
%       account in case mode = 'x', 'X', 'y', 'Y', 'z', 'or 'Z'.
%
%% Output arguments %%
%
%       [-Rx-]
% - R : [-Ry-] numeric -array of- vector(s), the resulting rotated vector.
%       [-Rz-]
%
%% Example %%
%
%%% 2*pi/3 rotation of i vector around [1 1 1]' is j vector
% V = [1 0 0]';
% mode = 'any';
% u = [1 1 1]';
% theta = 2*pi/3;
% R = rotate_3D(V, mode, theta, u)
%
%% Input wrangling %%
%
assert(nargin == 4, 'Error : too few or too many input arguments. rotate_3D takes exactly four input arguments');
assert(size(V,1) <= 3 && size(V,1) > 0, 'Error : V dimension must be stricltly positive and less or equal to three.');
assert(norm(u) ~= 0, 'Error : u must not equal to null vector.');
assert(size(u,1) == 3, 'Error : u dimension must exactly equals to three.');
assert(imag(theta) == 0, 'Error : theta must be real number.');
u = u/norm(u);
if (size(V,1) < 3)
    V = cat(1, V, zeros(3-size(V,1), size(V,2)));
end
%
%% Rotation matrix construction %%
%
switch(mode)
    case {'x', 'X'} % X axis rotation matrix ; u = i = [1 0 0]'
        Rm = [1          0           0;
              0 cos(theta) -sin(theta);
              0 sin(theta)  cos(theta)];        
    case {'y', 'Y'} % Y axis rotation matrix ; u = j = [0 1 0]'
        Rm = [cos(theta)   0  sin(theta);
              0            1           0;
              -sin(theta)  0  cos(theta)];        
    case {'z', 'Z'} % Z axis rotation matrix ; u = k = [0 0 1]'        
        Rm = [cos(theta) -sin(theta) 0;
              sin(theta)  cos(theta) 0;
              0           0          1];        
    case {'any', 'ANY'} % Any u axis rotation matrix        
        Rm = [u(1,1)^2+cos(theta)*(1-u(1,1)^2) (1-cos(theta))*u(1,1)*u(2,1)-u(3,1)*sin(theta) (1-cos(theta))*u(1,1)*u(3,1)+u(2,1)*sin(theta);
              (1-cos(theta))*u(1,1)*u(2,1)+u(3,1)*sin(theta) u(2,1)^2+cos(theta)*(1-u(2,1)^2) (1-cos(theta))*u(2,1)*u(3,1)-u(1,1)*sin(theta);
              (1-cos(theta))*u(1,1)*u(3,1)-u(2,1)*sin(theta) (1-cos(theta))*u(2,1)*u(3,1)+u(1,1)*sin(theta) u(3,1)^2+cos(theta)*(1-u(3,1)^2)];        
    otherwise
        error('Bad mode argument : mode must be ''x''/''X'', ''y''/''Y'', ''z''/''Z'', or ''any''/''ANY''.');
end
R = Rm * V;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%rotate_3D
