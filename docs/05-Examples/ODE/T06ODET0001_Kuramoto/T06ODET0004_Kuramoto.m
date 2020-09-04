
%% 
% In this tutorial, we present how to use Pontryagin environment to
% control a consensus system that models the complex emergent dynamics over 
% a given network. The control basically minimize the cost functional which
% contains the running cost and desired final state.
%% Model
% The Kuramoto model describes the phases $\theta_i$ of active oscillators,
% which is described by the following dynamics:
%%
% $$\dot \theta_i = \omega_i + \frac{1}{N}\sum_{j=1}^N K_{i,j}
% \sin(\theta_j-\theta_i),\quad i =1,\cdots,N.$$
%%
% Here, the first constant terms $\omega_i$ denote the natural oscillatory
% behaviors, and the interactions are nonlinearly affected by the relative
% phases. The amplitude and connections of interactions are determined by
% the coupling strength, $K_{i,j}$.
%% Control strategy
% The control interface is on the coupling strength as follows:
%%
% $$\dot \theta_i(t) = \omega_i + \frac{u(t)}{N}\sum_{j=1}^N K_{i,j}
% \sin(\theta_j(t)-\theta_i(t)),\quad i =1,\cdots,N.$$
%%
% This is a nonlinear version of bi-linear control problem for the Kuramoto
% interactions. The idea is as follows;
%%
% 1. There are $N$ number of oscillators, oscillating with
% their own natural frequencies.
%
% 2. We want to make a collective behavior using their own decision
% process. The interaction is given by the Kuramoto model, or may follow
% other interaction rules. The network can be given or flexible with
% control.
%
% 3. The cost of control will be related to the collective dynamics we
% want, such as the variance of frequencies or phases.
%
%% Numerical simulation
% Here, we consider a simple problem: we control the all-to-all network
% system to get gathered phases at final time $T$.
% We first need to define the system of ODEs in terms of symbolic variables.
%%
clear all
m = 20;  % [m]: number of oscillators.

import casadi.*

t     = SX.sym('t');
symTh = SX.sym('y', [m,1]);   % [y] :  phases of oscillators, $\theta_i$.
symOm = SX.sym('om', [m,1]);  % [om]:  natural frequencies of osc., $\omega_i$.
symK  = SX.sym('K',[m,m]);    % [K] :  the coupling network matrix, $K_{i,j}$.
symU  = SX.sym('u',[1,1]);    % [u] :  the control function along time, $u(t)$.


syms Vsys;    % [Vsys]: the vector fields of ODEs.
symThth = repmat(symTh,[1 m]);
%%
Vsys = casadi.Function('V',{symOm,symK,symTh,symU},{ symOm + (symU./m)*sum(symK.*sin(repmat(symTh,[1 m]).' - repmat(symTh,[1 m])),2) });   % Kuramoto interaction terms.

%%
% The parameter $\omega_i$ and $K_{i,j}$ should be specified for the
% calculations. Practically, $K_{i,j}u(t) > \vert \max\Omega - \min\Omega \vert$
% leads to the synchronization of frequencies. We normalize the coupling
% strength to 1, and give random values for the natural frequencies from
% the normal distribution $N(0,0.1)$. We also choose initial data from $N(0,\pi/4)$. 
%%
rng('default');
rng(1,'twister');
Om_init = normrnd(0,0.2,m,1);
Om_init = Om_init - mean(Om_init);  % Mean zero frequencies
Th_init = normrnd(0,pi/8,m,1);    
%%
K_init = ones(m,m);                 % Constant coupling strength, 1.
T = 7;                              % We give enough time for the frequency synchronization.

file = 'T06ODET0004_Kuramoto.m';
path_data = replace(which(file),file,'');

%%
symF = casadi.Function('F',{t,symTh,symU},{Vsys(Om_init,K_init,symTh,symU)});

tspan = linspace(0,T,100);
odeEqn = ode(symF,symTh,symU,tspan);
SetIntegrator(odeEqn,'RK4')
odeEqn.InitialCondition = Th_init;
%%
% We next construct cost functional for the control problem.
PathCost  = casadi.Function('L'  ,{t,symTh,symU},{ (1/2)*(symU'*symU)           });
FinalCost = casadi.Function('Psi',{symTh}      ,{  1e6*(1/m^2)*sum(sum((symThth.' - symThth).^2))  });

iCP_1 = ocp(odeEqn,PathCost,FinalCost);

%% Solve Gradient descent
tic
ControlGuess = ZerosControl(odeEqn);
[OptControl_1 ,OptThetaVector_1] =  ArmijoGradient(iCP_1,ControlGuess);
%[OptControl_1 ,OptThetaVector_1] =  IpoptSolver(iCP_1,ControlGuess,'Integrator','BackwardEuler');
toc
%% Visualization
% First, we present the dynamics without control,
FreeThetaVector = solve(odeEqn,ControlGuess);
FreeThetaVector = full(FreeThetaVector);
figure
plot(FreeThetaVector')
ylabel('Phases [rad]')
xlabel('Time [sec]')
title('The dynamics without control (incoherence)')
%%
% and see the controled dynamics.
figure
plot(OptThetaVector_1')
ylabel('Phases [rad]')
xlabel('Time [sec]')
title("The dynamics under control L^2 | N_{osc}="+m)

%%
% We also can plot the control function along time.
figure
plot(OptControl_1)
legend("norm(u(t)) = "+norm(OptControl_1))
ylabel('u(t)')
xlabel('Time [sec]')
title('The control function')
%% The problem with different regularization
% In this part, we change the regularization into $L^1$-norm and see the
% difference.

PathCost  = casadi.Function('L'  ,{t,symTh,symU},{ sqrt(symU.^2+1e-3)});
iCP_2 = ocp(odeEqn,PathCost,FinalCost);

%%
tic
[OptControl_2 ,OptThetaVector_2] =  ArmijoGradient(iCP_2,ControlGuess);
toc
%%
figure

line(tspan,OptThetaVector_2')
ylabel('Phases [rad]')
xlabel('Time [sec]')
title("The dynamics under control L^1 | N_{osc}="+m)

%% 
figure
plot(OptControl_1)
line(1:length(OptControl_2),OptControl_2,'Color','red')

Psi_1 = norm(sin(OptThetaVector_1(:,end).' - OptThetaVector_1(:,end)),'fro');
Psi_2 = norm(sin(OptThetaVector_2(:,end).' - OptThetaVector_2(:,end)),'fro');

legend("u(t) with L^2-norm; Terminal cost = "+Psi_1,"u(t) with L^1-norm; Terminal cost = "+Psi_2)
ylabel('The coupling strength (u(t))')
xlabel('Time [sec]')
title('The comparison between two different control cost functionals')

%%
% As one can expected from the regularization functions, the control function
% from $L^2$-norm acting more smoothly from $0$ to the largest value. The
% function from $L^2$-norm draws much stiff lines.

%%
YFr = FreeThetaVector';
YL1 = OptThetaVector_1';
YL2 = OptThetaVector_2';
%
%animationpendulums({YFr,YL1,YL2},tspan,{'Free','L^2 Control','L^1 Control'})
%%
% ![](extra-data/animation.gif)