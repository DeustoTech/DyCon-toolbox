addpath(genpath('/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox-V2'))

clear
T = 4;
Nt = 800;
tspan = linspace(0,T,Nt);


s0 = [0    ; ... % q
      0.05 + 0*pi   ; ... % theta1
      0.05  ; ... % theta2
      0.0   ; ... % dq
      0.0   ; ... % dtheta1
      0.0];   ... % dtheta2 

%%
openloop = true;
if openloop
    import casadi.*
    % define optimal 
    Ss = SX.sym('x',6,1);As = SX.sym('u',1,1);ts = SX.sym('t');
    %
    EvolutionFcn = Function('f',{ts,Ss,As},{ cartpole_dynamics(ts,Ss,As) });
    %
    dynamics_obj = ode(EvolutionFcn,Ss,As,tspan);
    dynamics_obj.InitialCondition = s0;
    %
    PathCost  = Function('L'  ,{ts,Ss,As},{ 0 });
    FinalCost = Function('Psi',{Ss}      ,{ -exp(-(Ss(2:6).'*Ss(2:6))) });
    ocp_obj = ocp(dynamics_obj,PathCost,FinalCost);
    %
    U0 = 0*tspan;
    [OptControl ,OptState] = IpoptSolver(ocp_obj,U0);
    %
    afeedback = @(t,s) interp1(tspan(1:end),OptControl,t,'linear','extrap');   
else
    
    %% Feedback control LQR
    afeedback = lqr_feedbackcontrol(@cartpole_dynamics,1e5);
end
%%

%%
%%
f = @(t,s) cartpole_dynamics(t,s,afeedback(t,s));
[~,st] = ode45(f,tspan,s0);
%
%st = OptState';
at = [arrayfun(@(it) afeedback(tspan(it),st(it,:)'),1:Nt)];
%%

%% Animation 
% fig = figure(1); cartpole_animation(fig,st)
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
plot(tspan,at)
xlabel('time');ylabel('a(t)')