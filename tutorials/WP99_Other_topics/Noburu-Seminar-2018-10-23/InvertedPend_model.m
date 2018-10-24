clear all
clc

syms t;
syms x dx theta dtheta;
syms M m l g; 
syms Lgr Lgr_x Lgr_dx Lgr_theta Lgr_dtheta; 

% Define Lagrangian
Lgr = 1/2 * M*dx^2 + 2/3 * m*l^2*dtheta^2 + m*l*dx*dtheta*cos(theta)...
        + 1/2 *m*dx^2 - m*g*l*cos(theta);
Lgr_x = diff(Lgr,x);
Lgr_dx = diff(Lgr,dx);
Lgr_theta = diff(Lgr,theta);
Lgr_dtheta = diff(Lgr,dtheta);

% Compute derivatives of Lagrangian
% _f means functionalized
syms x_f(t) dx_f(t) theta_f(t) dtheta_f(t) Lgr_x_f Lgr_dx_f Lgr_theta_f Lgr_dtheta_f;
dx_f(t)=diff(x_f,t);
dtheta_f=diff(theta_f,t);

Lgr_dx_f = subs(Lgr_dx,[x dx theta dtheta],[x_f dx_f theta_f dtheta_f])
Lgr_theta_f = subs(Lgr_theta,[x dx theta dtheta],[x_f dx_f theta_f dtheta_f])
Lgr_dtheta_f = subs(Lgr_dtheta,[x dx theta dtheta],[x_f dx_f theta_f dtheta_f])

% Coumpute LHS of Lagrange equations of motion
syms Leq Eqn;
Leq = diff([Lgr_dx_f; Lgr_dtheta_f],t) - [Lgr_x; Lgr_theta_f];
syms Ddx Ddtheta u;
Leq = subs(Leq,[diff(x_f(t), t, t) , diff(theta_f(t), t, t) ],[Ddx, Ddtheta])-[u; 0];
Eqn = solve(Leq==0,[Ddx,Ddtheta]);

% Construct state space equations
syms x1 x2 x3 x4 X;
X = [x1;x2;x3;x4];
subs(Eqn.Ddx, [x_f, diff(x_f(t),t), theta_f, diff(theta_f(t),t)], [x1, x2, x3, x4]);
subs(Eqn.Ddtheta, [x_f, diff(x_f(t),t), theta_f, diff(theta_f(t),t)], [x1, x2, x3, x4]);

syms Nsys
Nsys = [x2;...
        subs(Eqn.Ddx, [x_f, diff(x_f(t),t), theta_f, diff(theta_f(t),t)], [x1, x2, x3, x4]);...
        x4;...
        subs(Eqn.Ddtheta, [x_f, diff(x_f(t),t), theta_f, diff(theta_f(t),t)], [x1, x2, x3, x4])];

syms F;
F = subs(Nsys,u,0);

syms Amat Bmat
Amat = subs(jacobian(F,X),[x1,x2,x3,x4],[0,0,0,0]);
Bmat = diff(subs(Nsys,[x1,x2,x3,x4],[0,0,0,0]),u);

% Physical parameters
% m = 0.3 [kg];
% M = 0.8 [kg];
% l = 0.25 [m];
% g = 9.8 [m/s^2];

A = double(subs(Amat,[m M l g],[0.3 0.8 0.25 9.8]));
B = double(subs(Bmat,[m M l g],[0.3 0.8 0.25 9.8]));


