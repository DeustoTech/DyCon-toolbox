%% Two drivers, Flexible time

clear all

% Parameters and the dynamics
Ne_sqrt = 5; Ne = Ne_sqrt^2;

Nd = 1; Nt = 80;
%
T = 6;
%
Ut = 0.5*[1;-1];

%% Define dynamics using CasADi
ts  = casadi.SX.sym('t');
sUe = casadi.SX.sym('ue',[2,Ne]);
sVe = casadi.SX.sym('ve',[2,Ne]);
sUd = casadi.SX.sym('ud',[2,Nd]);
sVd = casadi.SX.sym('vd',[2,Nd]);

sControl = casadi.SX.sym('U',[2,Nd]);

sY = [sUe(:);sVe(:);sUd(:);sVd];

symF = dynamic_Guidance(sY,sControl,Ne,Nd);

symF_ftn = casadi.Function('symF',{ts,sY,sControl},{ symF });
% symF_ftn is the vector field for the dynamics
%% Initial data
Y0 = CreateIntialCondition_Guidance(Ne,Nd);

%% Sample trajectory
tline = linspace(0,T,Nt+1); dt = T/Nt;
odeEqn = ode(symF_ftn,sY,sControl,tline);
SetIntegrator(odeEqn,'RK4')
odeEqn.InitialCondition = Y0;
%
beta = 1e-5;
L   = casadi.Function('L'  ,{ts,sY,sControl}, { 1/Ne*sum(sum((sUe-Ut).^2))  + beta/Nd*sum(sControl.^2)   });
Psi = casadi.Function('Psi',{sY            }, { 1/Ne*sum(sum((sUe-Ut).^2))                         });

iCP = ocp(odeEqn,L,Psi);
%%
tic
ControlGuess = -1+ZerosControl(odeEqn);
[OptControl,OptState] = ArmijoGradient(iCP,ControlGuess,'MinLengthStep',1e-8,'maxiter',100);
time_S = toc;
U1_tline = OptControl;
%%
GBR_figure(tline,OptState',OptControl',Ut);

