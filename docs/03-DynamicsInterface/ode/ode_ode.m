%%
% Create a symbolical variable
clear 
import casadi.*
xs = SX.sym('x',2,1);
us = SX.sym('u',2,1);
ts = SX.sym('t');
%%
% Define a dynamic as casadi Function
Fs = casadi.Function('F',{ts,xs,us},{ - xs(1) + us(1);
                                      - xs(2) + us(2)});
tspan = linspace(0,1,100);
%%
% And create a object ode
iode = ode(Fs,xs,us,tspan);
%%
iode