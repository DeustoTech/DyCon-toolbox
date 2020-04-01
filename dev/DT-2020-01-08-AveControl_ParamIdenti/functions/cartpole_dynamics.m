function ds = cartpole_dynamics(t,s,u,params)
%CARTPOLE_DYNAMICS Summary of this function goes here
%   Detailed explanation goes here
L1 = 1;
L2 = 1;
%
g = 9.8;
m1 = params.m1;
m2 = params.m2;
M = 50;
d1 = 1e-1;
d2 = 1e-1;
d3 = 1e-1;
%
%%%%%%%%%%%%%%%%%%%%%5%%%
ds = zeros(6,1,class(s));
%
q      = s(1);
theta1 = s(2);
theta2 = s(3);
dq     = s(4);
dtheta1= s(5);
dtheta2= s(6);
% q
ds(1) = dq -10*q;
% theta 1
ds(2) = dtheta1;
% theta 2
ds(3) = dtheta2;
%
Mt = [ M+m1+m2                  L1*(m1+m2)*cos(theta1)     m2*L2*cos(theta2) ; ...
       L1*(m1+m2)*cos(theta1)     L1^2*(m1+m2)             L1*L2*m2*cos(theta1-theta2) ; ...
       L2*m2*cos(theta2)          L1*L2*m2*cos(theta1-theta2)  L2^2*m2        ];
%
% v
f1 = L1*(m1+m2)*dtheta1^2*sin(theta1) + m2*L2*theta2^2*sin(theta2)      - d1*dq + u  ;
f2 = -L1*L2*m2*dtheta2^2*sin(theta1-theta2) + g*(m1+m2)*L1*sin(theta1)  - d2*dtheta1;
f3 =  L1*L2*m2*dtheta1^2*sin(theta1-theta2) + g*L2*m2*sin(theta2)       - d3*dtheta2; 


ds(4:6) = Mt\[f1;f2;f3];

end

