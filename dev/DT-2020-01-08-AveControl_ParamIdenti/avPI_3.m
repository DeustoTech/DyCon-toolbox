addpath(genpath('/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox-V2'))

clear

T =10;
Nt =1000;
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
N = 5;
DT = linspace(0,T,N);

s0_iter = s0;
for iter = 1:N-1 
    t0 = DT(iter);
    tf = DT(iter+1);
    %
    
    import casadi.*
    % define optimal 

    Ss = SX.sym('x',6,1);As = SX.sym('u',1,1);ts = SX.sym('t');
    %
    EvolutionFcn = Function('f',{ts,Ss,As},{  cartpole_dynamics(ts,Ss,As,params) });
    %
    tspan = linspace(t0,T, 75);
    dynamics_obj = ode(EvolutionFcn,Ss,As,tspan);
    dynamics_obj.InitialCondition = s0_iter;
    %
    PathCost  = Function('L'  ,{ts,Ss,As},{ (  (Ss.'*Ss) + 1*(As.'*As) ) });
    FinalCost = Function('Psi',{Ss}      ,{ (  (Ss.'*Ss) ) });

    ocp_obj = ocp(dynamics_obj,PathCost,FinalCost);
    %
    U0 =0*tspan;
    [OptControl ,OptState] = IpoptSolver(ocp_obj,U0,'integrator','CrankNicolson');

        %%
    afeedback = @(t,s) interp1(tspan(1:end),OptControl,t,'linear','extrap');   


    f = @(t,s) cartpole_dynamics(t,s,afeedback(t,s),params);

    tspan = linspace(t0,tf, 100);

    [tspan_iter{iter},st_iter{iter}] = CrankNicolson(f,tspan,s0_iter);
    
    st_iter{iter} = st_iter{iter}';
    s0_iter = st_iter{iter}(:,end);

end
%%
st = [st_iter{:}]';
tspan = [tspan_iter{:}];
%%
%st = OptState';
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
%%
subplot(3,1,3)
plot(tspan,at)
xlabel('time');ylabel('a(t)')

%%
