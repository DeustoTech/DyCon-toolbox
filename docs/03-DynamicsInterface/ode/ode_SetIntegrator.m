%%
% Create a symbolical variable
clear 
import casadi.*
xs = SX.sym('x',2,1);
us = SX.sym('u',2,1);
ts = SX.sym('t');
%%
% Define a dynamic as casadi Function
Fs = casadi.Function('F',{ts,xs,us},{ [- 2*xs(1) + us(1) ;
                                      - xs(2) + us(2)]    });
tspan = linspace(0,1.5,7);
%%
% And create a object ode
iode = ode(Fs,xs,us,tspan);
iode.InitialCondition = [1;1];
u0 = ZerosControl(iode);
%%
% Before solve ode object must be set Integrator
SetIntegrator(iode,'RK4')
xt_RK4 = solve(iode,u0)
%% 
SetIntegrator(iode,'RK8')
xt_RK8 = solve(iode,u0)
