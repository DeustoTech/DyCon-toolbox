clear all;close all
import casadi.*

Xs = SX.sym('x',2,1);
Us = SX.sym('u',2,1);
ts = SX.sym('t');
%
A = [ -2 +1;
      +1 -2];

B = [1 0;
     0 1];
%%
EvolutionFcn = Function('f',{ts,Xs,Us},{ A*Xs + B*Us });
%
tspan = linspace(0,2,10);
iode = ode(EvolutionFcn,Xs,Us,tspan);
SetIntegrator(iode,'RK4')
iode.InitialCondition = [1;2];
%%
epsilon = 1e4;
PathCost  = Function('L'  ,{ts,Xs,Us},{ Us'*Us           });
FinalCost = Function('Psi',{Xs}      ,{ epsilon*(Xs'*Xs) });

iocp = ocp(iode,PathCost,FinalCost)
