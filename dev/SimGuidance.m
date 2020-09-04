%% Two drivers, Flexible time

%import casadi.*
clear 
% Parameters and the dynamics
N_sqrt = 5; Nx = N_sqrt^2;

Mx = 1; Nt = 50;

tf = 4;

uf = 0.5*[-2;1];

%% Define dynamics using CasADi
t = casadi.SX.sym('t');
Ue = casadi.SX.sym('ue',[2,Nx]);
Ve = casadi.SX.sym('ve',[2,Nx]);
Ud = casadi.SX.sym('ud',[2,Mx]);
Vd = casadi.SX.sym('vd',[2,Mx]);

Ys = [Ue(:);Ve(:);Ud(:)];
Us = Vd(:);

square = @(u) (u(1,:).^2+u(2,:).^2);

f_e2 = @(x) repmat(48*exp(-8*x), [2 1]);

kpp= 3; 
dist_ref = 1/3/N_sqrt;

g_e2 = @(x) repmat(kpp*((-(x+1e-10)+dist_ref)./(x+1e-10)), [2 1]);
a_e2 = @(x) 1;

dot_ve = -Ve;
for j=1:Mx
  dot_ve = dot_ve -f_e2(square(Ud(:,j)-Ue)).*(Ud(:,j)-Ue)/2;
end
for j=1:Nx
 dot_ve = dot_ve -g_e2(square(Ue(:,j)-Ue)).*(Ue(:,j)-Ue)/(Nx-1);
end
for j=1:Nx
 dot_ve = dot_ve +a_e2(square(Ue(:,j)-Ue)).*(Ve(:,j)-Ve)/(Nx-1);
end

F = casadi.Function('F',{t,Ys,Us},{ [Ve(:)',dot_ve(:)',Us']' });

%% Initial data
[Y0] = InitialConditionGuidance(Nx,Mx,N_sqrt);
%% Sample trajectory
tline = linspace(0,tf,Nt+1); dt = tf/Nt;
odeEqn = ode(F,Ys,Us,tline);
SetIntegrator(odeEqn,'RK4')
odeEqn.InitialCondition = Y0;

%% Add Adjoint 
U0 = ZerosControl(odeEqn) + 0.35;
OptState = solve(odeEqn,U0);

%%
figure(3)
clf
GBR_figure(tline,full(OptState)',full(U0)',uf);
%%

Psi = casadi.Function('Psi',{Ys}     ,{ (1/Mx)*sum(sum((Ue - uf).^2)) });
L   = casadi.Function('L'  ,{t,Ys,Us},{ 1e-5*(Us'*Us)          });
% 
iCP = ocp(odeEqn,L,Psi);
%%
ControlGuess = 0.5+ZerosControl(odeEqn);
% 
opt = {'MinLengthStep',1e-5,'maxiter',500,'FunctionRelativeTol',1e-5};
[OptControl,OptState] = ArmijoGradient(iCP,ControlGuess,opt{:});
% %[OptControl,OptState] = ClassicalGradient(iCP,ControlGuess,'LengthStep',1e-3,'maxiter',500);
% %[OptControl,OptState] = IpoptSolver(iCP,ControlGuess);
%%
figure(3)
clf
GBR_figure(tline,OptState',OptControl',uf);
