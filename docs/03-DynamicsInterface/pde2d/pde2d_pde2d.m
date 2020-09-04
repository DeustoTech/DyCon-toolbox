%%
% Create a symbolical variable
clear 
import casadi.*
us = SX.sym('u',2,1);
vs = SX.sym('v',2,1);
ts = SX.sym('t');
%%
% Define a dynamic as casadi Function
Fs = casadi.Function('F',{ts,us,vs},{ - us(1) + vs(1);
                                      - us(2) + vs(2)});
tspan = linspace(0,1,100);
xline = linspace(0,1,100);
yline = linspace(0,1,100);
%%
% And create a object ode
ipde2d = pde2d(Fs,us,vs,tspan,xline,yline);
%%
ipde2d