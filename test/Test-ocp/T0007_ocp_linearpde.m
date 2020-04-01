clear all;close all
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

idyn.InitialCondition = sin(pi*xmesh'/L);
%%
Control0 = ZerosControl(idyn);
FreeState = solve(idyn,Control0);

ts = idyn.ts;
Xs = idyn.State.sym;
Us = idyn.Control.sym;
%
epsilon = 1e4;
PathCost  = Function('L'  ,{ts,Xs,Us},{ Us'*Us           });
FinalCost = Function('Psi',{Xs}      ,{ epsilon*(Xs'*Xs) });

iocp = pdeocp(idyn,PathCost,FinalCost);

ControlGuess = ZerosControl(idyn);
[OptControl ,OptState] = ClassicalGradient(iocp,ControlGuess);

%%
figure
subplot(1,2,1);
surf(OptState');
title('Optimal State')
subplot(1,2,2);
surf(FreeState')
title('Free')
