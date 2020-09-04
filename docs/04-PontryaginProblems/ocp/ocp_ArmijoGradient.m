import casadi.*

A = [-2  1;
      1 -2];
B = [1;0];
%
tspan = linspace(0,1,7);
idyn = linearode(A,B,tspan);
idyn.InitialCondition = [1;2];
%%
ts = idyn.ts;
Xs = idyn.State.sym;
Us = idyn.Control.sym;
%
epsilon = 1e4;
PathCost  = Function('L'  ,{ts,Xs,Us},{ Us'*Us           });
FinalCost = Function('Psi',{Xs}      ,{ epsilon*(Xs'*Xs) });

iocp = ocp(idyn,PathCost,FinalCost);
%%
uguess = tspan;
[uopt,xopt] = ArmijoGradient(iocp,uguess);
%%
uopt
%%
xopt