addpath(genpath('/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox-V2'))

clear
T = 10;
Nt = 200;
tspan = linspace(0,T,Nt);


s0 = [0    ; ... % q
      pi   ; ... % theta1
      pi  ; ... % theta2
      0.0   ; ... % dq
      0.0   ; ... % dtheta1
      0.0];   ... % dtheta2 
%%
params.m1 = 1;
params.m2 = 1;
%%

import casadi.*
% define optimal 
Ss = SX.sym('x',6,1);As = SX.sym('u',1,1);ts = SX.sym('t');
%
esti_params = params;
esti_params.m1 = 1.0;
EvolutionFcn = Function('f',{ts,Ss,As},{ cartpole_dynamics(ts,Ss,As,params) });
%
dynamics_obj = ode(EvolutionFcn,Ss,As,tspan);
dynamics_obj.InitialCondition = s0;
%
PathCost  = Function('L'  ,{ts,Ss,As},{ (Ss.'*Ss + 1e-2*(As.'*As) ) });
FinalCost = Function('Psi',{Ss}      ,{ (Ss.'*Ss ) });
ocp_obj = ocp(dynamics_obj,PathCost,FinalCost);
%
U0 = 0*tspan;
[OptControl ,OptState] = IpoptSolver(ocp_obj,U0,'integrator','CrankNicolson');
%
afeedback = @(t,s) interp1(tspan(1:end),OptControl,t,'linear','extrap');   
    
%% Feedback control LQR
%%

%% SIMULATION
%%
f = @(t,s) cartpole_dynamics(t,s,afeedback(t,s),params);
[~,st] = CrankNicolson(f,tspan,s0);
%%
%st = OptState';
clear MPC_LQR
at = [arrayfun(@(it) afeedback(tspan(it),st(it,:)'),1:Nt)];
%%

%% Animation 
%fig = figure(1); cartpole_animation(fig,st)
%%
subplot(3,1,1)
plot(tspan,st)
plot(tspan,st(:,[2 3]))
ylabel('states');xlabel('time')
legend({'\theta_1(t)','\theta_2(t)'})
subplot(3,1,2)
plot(tspan,st(:,1))
ylabel('x(t)');xlabel('time')
subplot(3,1,3)
%%
plot(tspan,at,'o-')
xlabel('time');ylabel('a(t)')