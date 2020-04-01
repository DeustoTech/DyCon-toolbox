clear all;close all
import casadi.*
%
%%
N = 2;
M = 1;
nu = linspace(1 ,2,M);
[A,B] = ABmatrixSimu_2(nu,N);
%%
Xs = SX.sym('x',N*M,1);
Us = SX.sym('u',1,1);
ts = SX.sym('t');
%%
XT = repmat(zeros(N,1),M,1);

EvolutionFcn = Function('f',{ts,Xs,Us},{ A*Xs + B*Us });

%
tspan = linspace(0,1,100);
% idyn = ode(EvolutionFcn,Xs,Us,tspan);
idyn = linearode(A,B,tspan);
%idyn.solver = @ode45;
idyn.InitialCondition = repmat(ones(N,1),M,1);

ZControl = ZerosControl(idyn);
FreeState = solve(idyn,ZControl);

%
epsilon = 1e-6;
% J = 0.5*||U||^2 + 0.5*(1/epsilon)*||Y(T) - Y_T ||^2
PathCost  = casadi.Function('L'  ,{ts,Xs,Us},{ (1/2)*(Us'*Us)  });
FinalCost = casadi.Function('Psi',{Xs}      ,{ 1e2*(1/2)*((Xs-XT)'*(Xs-XT)) });

iocp = ocp(idyn,PathCost,FinalCost);
iocp.TargetState = XT;
%%
ControlGuess = ZerosControl(idyn);
[OptControl ,OptState] = ClassicalGradient(iocp,ControlGuess,'Maxiter',1e4,'LengthStep',1e-4);
%[OptControl ,OptState] = ArmijoGradient(iocp,ControlGuess,'Maxiter',100,'MinLengthStep',1e-9);
%[OptControl ,OptState] = ConjugateGradient(iocp,ControlGuess,'Maxiter',100);

%%
U0 = ControlGuess(:,1:end-1);
[OptControl ,OptState] = IpoptSolver(iocp,U0);
%%
figure
subplot(1,2,1);
plot(OptState(1:2:N*M,:)')
title('X_1')
%ylim([-1 0.6])
subplot(1,2,2);
plot(OptState((2:2:N*M),:)')
title('X_2')
%ylim([-0.2 1.2])
%%
figure;
subplot(1,3,1)
plot(OptState')
ylim([-4 4])

title('Optimal')
subplot(1,3,2)
plot(FreeState')
ylim([-4 4])
title('Free')
subplot(1,3,3)
plot(OptControl)
title('Control')