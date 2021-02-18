function T0001_simple_ode
import casadi.*

T = 5;

Xs = SX.sym('x',2,1);
Us = SX.sym('u',2,1);
ts = SX.sym('ts');
EvolutionFcn = -cos(1*pi*Xs)*sin(2*pi*Xs(2)/T) + 2*sin(ts)+ eye(2)*Us ;
%
tspan = linspace(0,T,50);
isys = ode(EvolutionFcn,Xs,Us,ts,tspan);
%
isys.InitialCondition = [1;2];
%%
u0 = ZerosControl(isys);
xt = solve(isys,u0);
