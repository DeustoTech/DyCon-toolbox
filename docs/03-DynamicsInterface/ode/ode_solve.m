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
tspan = linspace(0,1,10);
%%
% And create a object ode
iode = ode(Fs,xs,us,tspan);
SetIntegrator(iode,'LinearBackwardEuler')
iode.InitialCondition = [1;1];
%%
u0 = ZerosControl(iode);
xt = solve(iode,u0);
%%
xt
%%
class(xt)