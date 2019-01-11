%% 
% In this tutorial, we present how to use OptimalControl environment to
% control a consensus system that models the complex emergent dynamics over 
% a given network. The control basically minimize the cost functional which
% contains the running cost and desired final state.
%% Model
% The Kuramoto model describes the phases dollars\theta_idollars of active oscillators,
% which is described by the following dynamics:
%%
%
% dollars-dollars\dot \theta_i = \omega_i + \frac{\kappa}{N}\sum_{j=1}^N
% \sin(\theta_j-\theta_i),\quad i =1,\cdots,N.dollars-dollars
%
%%
% Here the first constant terms dollars\omega_idollars denote the natural oscillatory
% behaviors, and the interactions are nonlinearly affected by the relative
% phases. The amplitude of interactions is determined by the coupling
% strength, dollars\kappadollars.
%%
% We control the system to achevie the synchronization of frequencies.
%
% dollars-dollars\dot \theta_i = \omega_i + \frac{\kappa+u}{N}\sum_{j=1}^N K_{ij}
% \sin(\theta_j-\theta_i),\quad i =1,\cdots,N,dollars-dollars
%
% where the control is on the coupling strength. This is a
% nonlinear version of bi-linear control problem for the Kuramoto
% interactions.
%
% We first define the system of ODEs in terms of symbolic variables.
clear all
clc

m = 5;  % [m]: number of oscillators.

syms t;
symTh = sym('y', [m,1]);  % [y]: phases of oscillators, dollars\theta_idollars.
symOm = sym('om', [m,1]);  % [om]: natural frequencies of osc., dollars\omega_idollars.
symK = sym('K',[1,1]); % [K]: the coupling network matrix, dollars\kappadollars.
symU = sym('u',[1,1]); % [u]: the control functions along time, dollarsu(t)dollars.

syms Vsys;   % [Vsys]: the vector fields of ODEs.
symThth = repmat(symTh,[1 m]);
Vsys = symOm + (1./m)*sum((symK+symU).*sin(symThth.' - symThth),2);   % Kuramoto interaction terms.

%%
% The parameter dollars\omega_idollars and dollars\kappadollars should be specified for the
% calculations. We normalize the coupling strength to 1 and give random
% values for the natural frequencies. 

K_init = 1.0;                       % Coupling strength is normalized to 1.
T = 5;                              % We give enough time for the frequency synchronization.

%%
% Practically, any dollarsKdollars with positive elements can make the limit point to be 0, e.g., K=[1,1,1].
%
% The initial condition is chosen on dollars[-0.55\pi,0.55\pi]dollars by
%
%    ini = 0.55*pi()*(2*(rand(m,1)-0.5));
%
% which is stored in the functions folder, 'functions/ini.mat'.
%%
% random data
%
% Om_init = normrnd(0,0.1,m,1);
% Om_init = Om_init - mean(Om_init);  % Natural frequencies are chosen by the normal distribution with mean 0 and std 0.1.
% 
% Th_init = normrnd(0,pi()/4,m,1);    % Initial phases follows the normal distribution with mean 0 and std pi/4.
load('functions/random_init.mat','Om_init','Th_init'); % Safe data
%%
symF = subs(Vsys,[symOm;symK],[Om_init;K_init]);
odeEqn = ode(symF,symTh,symU,'Y0',Th_init,'T',T);
%%
% We next construct cost functional for the control problem.
symPsi = norm(symThth.' - symThth,'fro');
symL_1 = 0.001*(symU.'*symU);              % Set the L^2 regulation for the control dollarsu(t)dollars.
%
Jfun_1 = Functional(symPsi,symL_1,symTh,symU,'T',T);
%
iCP_1 = ControlProblem(odeEqn,Jfun_1);
%% Solve Gradient descent
tic
GradientMethod(iCP_1)
toc
%% Visualization
% First, we present the dynamics without control,
solve(odeEqn)
figure
plot(odeEqn.tline',odeEqn.Y(:,:))
legend('\theta_'+[1:m])
ylabel('Phases [rad]')
xlabel('Time [sec]')
title('The dynamics without control')
%%
% and see the controled dynamics.
odec_1 = iCP_1.ode;
clf
plot(odec_1.tline',odec_1.Y(:,:))
%plot(odec.tline',odec.Y(:,1),'Color','red')
%line(odec.tline',odec.Y(:,2),'Color','green')
legend('\theta_'+[1:m])
ylabel('Phases [rad]')
xlabel('Time [sec]')
title('The dynamics under control')

%%
% We also can plot the control function along time.
clf
Ufinal_1 = iCP_1.Uhistory{iCP_1.iter+1};
plot(odec_1.tline',Ufinal_1)
legend('norm(u(t)) = '+norm(Ufinal_1))
ylabel('u(t)')
xlabel('Time [sec]')
title('The control function')
%% Optimal control problem with different cost regulations
% In this part, we change the regulation into L^1-norm and see the
% difference.

symL_2 = 0.001*abs(1+symU);
Jfun_2 = Functional(symPsi,symL_2,symTh,symU,'T',T);
iCP_2 = ControlProblem(odeEqn,Jfun_2);

%% Calculations and visualization
% 
tic
GradientMethod(iCP_2)
toc
%%
odec_2 = iCP_2.ode;
clf
plot(odec_2.tline',odec_2.Y(:,:))
% plot(odec.tline',odec.Y(:,1),'Color','red')
% line(odec.tline',odec.Y(:,2),'Color','green')
legend('\theta_'+[1:m])
ylabel('Phases [rad]')
xlabel('Time [sec]')
title('The dynamics under control with different regulation')

%%
Ufinal_2 = iCP_2.Uhistory{iCP_2.iter+1};
clf
plot(odec_1.tline',Ufinal_1+1)
line(odec_2.tline',Ufinal_2+1,'Color','red')

Thfinal_1 = odec_1.Y(end,:);
Thfinal_2 = odec_2.Y(end,:);
Psi_1 = norm(Thfinal_1.' - Thfinal_1,'fro');
Psi_2 = norm(Thfinal_2.' - Thfinal_2,'fro');

legend('\kappa+u(t) with L^2-norm; Terminal cost = '+Psi_1,'\kappa+u(t) with L^1-norm; Terminal cost = '+Psi_2)
ylabel('The coupling strength (\kappa+u(t))')
xlabel('Time [sec]')
title('The comparison between two different control cost functionals')

%%
% As one can expected from the regulation functions, the control function
% from dollarsL^2dollars-norm acting more smoothly from 0 to the largest value. The
% function from dollarsL^2dollars-norm draws more straight lines.
