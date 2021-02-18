function T0007_ocp_linearpde

import casadi.*
%%
Nt = 40;
Nx = 50;
T = 0.5;
L = 1.5;
xmesh = linspace(-L,L,Nx);
tspan = linspace(0,T,Nt);

A = FDLaplacian(xmesh);
B = BInterior(xmesh,-0.5,0.5);
%
idyn = linearpde1d(A,B,tspan,xmesh);
%
idyn.InitialCondition = sin(pi*xmesh'/L);
%%
Control0 = ZerosControl(idyn);
FreeState = solve(idyn,Control0);
%
[ts,Xs,Us] = symvars(idyn);
%
PathCost  =  1e-3*(Us'*Us)       ;
FinalCost =  (Xs'*Xs) ;

iocp = pdeocp(idyn,PathCost,FinalCost);

ControlGuess = ZerosControl(idyn);
[OptControl ,OptState] = ArmijoGradient(iocp,ControlGuess);
