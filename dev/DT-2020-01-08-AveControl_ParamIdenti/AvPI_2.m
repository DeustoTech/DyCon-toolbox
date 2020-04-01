addpath(genpath('/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox-V2'))

clear

T =5;
Nt =400;
%
tspan = linspace(0,T,Nt);


s0 = [0.0   ; ... % q
      pi    ; ... % theta1
      pi    ; ... % theta2
      0.0   ; ... % dq
      0.0   ; ... % dtheta1
      0.0  ];   ... % dtheta2 

  
%%
params.m1 = 1;
params.m2 = 1;
%%

%%
N = 10;

afeedback = point2LQR(@cartpole_dynamics,params,zeros(6,1),0);
%%
%%
f = @(t,s) cartpole_dynamics(t,s,afeedback(t,s),params);

[tspan,st] = ode45(f,tspan,s0);
%%
st = OptState';
at = [arrayfun(@(it) afeedback(tspan(it),st(it,:)'),1:length(tspan))];
%% Animation 
%%
figure(6)
subplot(3,1,1)
plot(tspan,st(:,2:3))
legend({'\theta_1','\theta_2'})
ylabel('States');xlabel('time')
subplot(3,1,2)
plot(tspan,st(:,5:6))
legend({'\omega_1','\omega_2'})
ylabel('\theta_2(t)');xlabel('time')
subplot(3,1,3)
plot(tspan,at)
xlabel('time');ylabel('a(t)')

%%
