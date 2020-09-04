clear all
import casadi.*
%

Nt = 50;
Nx = 50;
T = 5.0;
L = 2.0;
xmesh = linspace(-L,L,Nx+2);
xmesh = xmesh(2:end-1);
tspan = linspace(0,T,Nt);

A = FDLaplacian(xmesh);
B = BInterior(xmesh,-0.5,0.5,'min',true);
B = zeros(Nx,1);
B(1,1) = 1;
B(end,end) = 1;

[Nx,Nu] = size(B);
Ys = SX.sym('y',Nx,1);
Us = SX.sym('u',Nu,1);
ts = SX.sym('t');

%
theta = 0.2;
NonLinearTerm = Function('NLT',{Ys},{(Ys-theta)});
%  
idyn = semilinearpde1d(Ys,Us,A,B,NonLinearTerm,tspan,xmesh);

idyn.InitialCondition = cos(0.5*pi*xmesh'/L);

ZControl = ZerosControl(idyn);
FreeState = solve(idyn,ZControl);
%%

epsilon = (L/Nx)^1;

YT = 0.2 + 0*xmesh';
PathCost  = Function('L'  ,{ts,Ys,Us},{ Us.'*Us  });
FinalCost = Function('Psi',{Ys}      ,{ 1/(2*epsilon)*((Ys-YT).'*(Ys-YT)) });

iocp = ocp(idyn,PathCost,FinalCost);
iocp.TargetState = 0*xmesh';
%%
ControlGuess = 1+ZerosControl(idyn) ;

%%
%[OptControl ,OptState]  = IpoptSolver(iocp,ControlGuess,'integrator','SemiLinearBackwardEuler');
[OptControl ,OptState]  = ArmijoGradient(iocp,ControlGuess);

%%
subplot(1,3,1);
surf(OptState');
title('Optimal State')
subplot(1,3,2);
surf(full(FreeState'))
title('Free')
subplot(1,3,3);
plot(OptControl');
title('Optimal State')
