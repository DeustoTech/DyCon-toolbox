function T0008_ocp_linearode_Armijo

import casadi.*

%
A = [-2 1;
      1 -2];

B = [1;0];
%
tspan = linspace(0,1,50);

ts = casadi.SX.sym('ts');
idyn = linearode(A,B,ts,tspan);
idyn.InitialCondition = [1;2];

U0 = ZerosControl(idyn);
FreeState = solve(idyn,U0);
%
[ts,Xs,Us] = symvars(idyn);
%
epsilon = 1e4;
PathCost  =  Us'*Us          ;
FinalCost = epsilon*(Xs'*Xs) ;
iocp = ocp(idyn,PathCost,FinalCost);

ControlGuess = ZerosControl(idyn);
[OptControl ,OptState] = ArmijoGradient(iocp,ControlGuess);

%%