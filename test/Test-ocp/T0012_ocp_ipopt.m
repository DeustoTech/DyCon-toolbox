clear all;close all
import casadi.*
%%
Nt = 50;
Nx = 50;
T = 0.1;
L = 1.5;
xmesh = linspace(-L,L,Nx);
tspan = linspace(0,T,Nt);

A = FDLaplacian(xmesh);
B = BInterior(xmesh,-0.6,0.6);
%
idyn = linearpde1d(A,B,tspan,xmesh);

idyn.InitialCondition = sin(pi*xmesh'/L);
%%
U0 = ZerosControl(idyn);
FreeState = solve(idyn,U0);

ts = idyn.ts;
Xs = idyn.State.sym;
Us = idyn.Control.sym;
%
epsilon = (L/Nx)^4;
PathCost  = Function('L'  ,{ts,Xs,Us},{ epsilon*(Us'*Us)           });
FinalCost = Function('Psi',{Xs}      ,{ (Xs'*Xs) });

iocp = ocp(idyn,PathCost,FinalCost);

ControlGuess = ZerosControl(idyn);
[OptControl ,OptState] = IpoptSolver(iocp,ControlGuess);

%%
figure
subplot(1,3,1);
surf(OptState');
title('Optimal State')
subplot(1,3,2);
surf(FreeState')
title('Free')

subplot(1,3,3);
surf(OptControl')
title('Control')
