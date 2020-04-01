addpath(genpath('/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox-V2'))

clear
T = 20;
Nt = 500;
tspan = linspace(0,T,Nt);


s0 = [0    ; ... % q
      0   ; ... % theta1
      0.01  ; ... % theta2
      0.0   ; ... % dq
      0.5   ; ... % dtheta1
      0.5];   ... % dtheta2 
%%
params.m1 = 1;
params.m2 = 1;
%%
afeedback = @(t,s) sin(t);   
    
%% Feedback control LQR
%%

%% SIMULATION
%%
f = @(t,s) cartpole_dynamics(t,s,afeedback(t,s),params);
[~,st] = ode45(f,tspan,s0);
%%
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