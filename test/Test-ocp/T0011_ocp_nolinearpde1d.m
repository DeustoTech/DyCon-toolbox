clear all
import casadi.*
%

Nt = 50;
Nx = 50;
T = 20.0;
L = 5.0;
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
NonLinearTerm = Function('NLT',{Ys},{Ys.*(Ys-theta)});
%  
idyn = semilinearpde1d(Ys,Us,A,B,NonLinearTerm,tspan,xmesh);

%idyn.solver = @Domenec;
idyn.InitialCondition = cos(0.5*pi*xmesh'/L);

ZControl = ZerosControl(idyn);
FreeState = solve(idyn,ZControl);
%%

epsilon = (L/Nx)^4;

YT = 0.2 + 0*xmesh';
PathCost  = Function('L'  ,{ts,Ys,Us},{ Us.'*Us + 1/(2*epsilon)*((Ys-YT).'*(Ys-YT))  });
FinalCost = Function('Psi',{Ys}      ,{ 1/(2*epsilon)*((Ys-YT).'*(Ys-YT)) });

iocp = ocp(idyn,PathCost,FinalCost);
iocp.TargetState = 0*xmesh';
%%
ControlGuess = 1+ZerosControl(idyn) ;

%[OptControl ,OptState]  = ClassicalGradient(iocp,ControlGuess,'MaxIter',100,'LengthStep',1e-6);
%[OptControl ,OptState]  = ArmijoGradient(iocp,ControlGuess,'MaxIter',50);

%%
% [OptControl ,OptState]  = ConjugateGradient(iocp,ControlGuess,'MaxIter',200);
[OptControl ,OptState]  = IpoptSolver(iocp,ControlGuess,'integrator','SemiLinearBackwardEuler');
%%
subplot(1,3,1);
surf(OptState');
title('Optimal State')
subplot(1,3,2);
surf(FreeState')
title('Free')
subplot(1,3,3);
plot(OptControl');
title('Optimal State')
