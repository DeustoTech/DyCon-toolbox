%% Parametros de discretizacion
N = 50;
xi = -1; xf = 1;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
dx = xline(2) - xline(1);
%% Creamos el ODE 
A = FDLaplacian(xline);
%%%%%%%%%%%%%%%%  
a = -0.4; b = 0.9;
B = BInterior(xline,a,b,'min',false);
%%%%%%%%%%%%%%%%
FinalTime = 0.1;
Nt = 100;
Y0 =sin(pi*xline');
tspan = linspace(0,FinalTime,Nt);
dynamics = linearpde1d(A',B,tspan,xline);
dynamics.InitialCondition = Y0;
%% Creamos Problema de Control
Y = dynamics.State.sym;
U = dynamics.Control.sym;
import casadi.*
ts = SX.sym('t');

YT = 0*cos(pi*xline');
PathCost  = casadi.Function('L'  ,{ts,Y,U},{ (1/2)*(U'*U) });
FinalCost = casadi.Function('Psi',{Y}      ,{ 1e5*(1/2)*((Y-YT)'*(Y-YT)) });

iCP1 = ocp(dynamics,PathCost,FinalCost);
%%
iCP1.TargetState = YT;
%% Solve Gradient
tol = 1e-5;
%
U0 =ZerosControl(dynamics);
[OptControl ,OptState] = ArmijoGradient(iCP1,U0,'Maxiter',100);
%[OptControl ,OptState] = IpoptSolver(iCP1,U0);

%%
State = solve(dynamics,U0);

%%
surf(OptState)
