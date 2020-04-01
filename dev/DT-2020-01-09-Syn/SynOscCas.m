
clear all
m = 3;  % [m]: number of oscillators.

import casadi.*

t     = SX.sym('t');
symTh = SX.sym('y', [m,1]);   % [y] :  phases of oscillators, $\theta_i$.
symOm = SX.sym('om', [m,1]);  % [om]:  natural frequencies of osc., $\omega_i$.
symK  = SX.sym('K',[m,m]);    % [K] :  the coupling network matrix, $K_{i,j}$.
symU  = SX.sym('u',[1,1]);    % [u] :  the control function along time, $u(t)$.


syms Vsys;    % [Vsys]: the vector fields of ODEs.
symThth = repmat(symTh,[1 m]);
%%
B = zeros(m,1);
B(end,end) = 1;
%
Vsys = casadi.Function('V',{symOm,symK,symTh,symU}, ...
                           { symOm + (((B*(symU-1) + 1))./m).*sum(symK.*sin(repmat(symTh,[1 m]).' - repmat(symTh,[1 m])),2) });   % Kuramoto interaction terms.

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
%%
K_init = 5*ones(m,m);                 % Constant coupling strength, 1.
T = 1;                              % We give enough time for the frequency synchronization.

file = 'T06ODET0004_Kuramoto.m';
path_data = replace(which(file),file,'');

%%
symF = casadi.Function('F',{t,symTh,symU},{Vsys(Om_init,K_init,symTh,symU)});

tspan = linspace(0,T,150);
odeEqn = ode(symF,symTh,symU,tspan);
odeEqn.InitialCondition = Th_init;
%%
% We next construct cost functional for the control problem.
PathCost  = casadi.Function('L'  ,{t,symTh,symU},{ 0*(1/2)*(symU'*symU)           });
FinalCost = casadi.Function('Psi',{symTh}      ,{  1e3*sum(sum((symThth.' - symThth).^2))  });

iCP_1 = ocp(odeEqn,PathCost,FinalCost);

%% Solve Gradient descent
tic
ControlGuess = ZerosControl(odeEqn);
%[OptControl_1 ,OptThetaVector_1] = ClassicalGradient(iCP_1,ControlGuess,'maxiter',100);
%[ControlGuess ,OptThetaVector_1] = ArmijoGradient(iCP_1,ControlGuess,'maxiter',100);

[OptControl_1 ,OptThetaVector_1] =  IpoptSolver(iCP_1,ControlGuess(:,1:end-1));
toc
%%
%ControlGuess = 10+ZerosControl(odeEqn);
%U0 = ControlGuess(:,1:end-1);
%[OptControl_1 ,OptThetaVector_1] = IpoptSolver(iCP_1,U0);
%% Visualization
% First, we present the dynamics without control,
FreeThetaVector = solve(odeEqn,0*ControlGuess);

figure
plot(FreeThetaVector')
legend("\theta_"+[1:m])
ylabel('Phases [rad]')
xlabel('Time [sec]')
title('The dynamics without control (incoherence)')
%%
% and see the controled dynamics.
figure
plot(OptThetaVector_1')
legend("\theta_"+[1:m])
ylabel('Phases [rad]')
xlabel('Time [sec]')
title('The dynamics under control')

%%
% We also can plot the control function along time.
figure
plot(OptControl_1')
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
% 
tic
U0 = ControlGuess(:,1:end-1);
[OptControl_2 ,OptThetaVector_2] =  IpoptSolver(iCP_2,U0);
toc
%%
%%
figure
plot(tspan,OptThetaVector_2)
legend("\theta_"+[1:m])
ylabel('Phases [rad]')
xlabel('Time [sec]')
title('The dynamics under control with different regularization')

%% 
figure
plot(tspan(1:end-1),OptControl_1)
line(tspan(1:end-1),OptControl_2,'Color','red')

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