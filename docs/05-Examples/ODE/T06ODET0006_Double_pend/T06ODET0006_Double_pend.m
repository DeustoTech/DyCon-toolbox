
clear
T = 10;
Nt = 250;
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
EvolutionFcn =  cartpole_dynamics(ts,Ss,As,params);
%
dyn = ode(EvolutionFcn,ts,Ss,As,tspan);
dyn.InitialCondition = s0;
SetIntegrator(dyn,'RK4')
%
PathCost  = (Ss.'*Ss) + 1e-3*(As.'*As) ;
FinalCost =  (Ss.'*Ss ) ;
ocp_obj = ocp(dyn,PathCost,FinalCost);

% ocp_obj.constraints.MaxControlValue = +1e3;
% ocp_obj.constraints.MinControlValue = -1e3;

%%
U0 = 1e3*rand(size(ZerosControl(dyn)));
[OptControl ,OptState] = IpoptSolver(ocp_obj,U0,'odeSolver','rk4');
%%
%OptState = full(solve(dyn,OptControl));
%
%% Animation 
st = OptState';
fig = figure(1); cartpole_animation_several(fig,st,tspan,1)
%%
figure(2)
clf
subplot(2,1,1)
plot(tspan,st)
plot(tspan,st(:,[2 3]))
ylabel('states');xlabel('time')
legend({'\theta_1(t)','\theta_2(t)'})
subplot(2,1,2)
plot(tspan,OptControl)
xlabel('t');
ylabel('u(t)');
