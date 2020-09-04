%%
%% Semi-linear semi-discrete heat equation and collective behavior
%%
% Definition of the time 
clear all
% Discretization of the space

Nx = 30;
xi = -2; xf = 2;
xline = linspace(xi,xf,Nx+2);
xline = xline(2:end-1);

dx = xline(2) - xline(1);
%%
import casadi.*

Ys = SX.sym('y',Nx,1);
Us = SX.sym('u',Nx,1);
ts = SX.sym('t');
% Dynamics 
A = FDLaplacian(xline);
B = speye(Nx);
%%
epsilon = 1e-1;
alpha = 1e-1;
%
relu =  @(Y)(0<Y).*(Y<alpha).*(Y.^2/(2*alpha))+(Y>alpha).*(Y-alpha/2);
expon = @(x) 0.2*exp(-x.^2/0.5^2)';        
%
NonLinTerm = Function('N',{Ys},{     -1                                     ...  % source
                                 + (1/epsilon).*relu(-Ys + expon(xline))    ...  % obstacle
                                 + (1/dx^2).*[0.8;zeros(Nx-2,1);0.8]        ...  % BC Dirichlet
                                } );
%
tspan = linspace(0,1.0,100);

Fs = Function('f',{ts,Ys,Us},{ A*Ys + B*Us + NonLinTerm(Ys) });
idyn = pde1d(Fs,Ys,Us,tspan,xline);
SetIntegrator(idyn,'RK4')

idyn.InitialCondition = InitialConditionFcn(xline);

%% Free Solution

dae = struct('x',Ys,'ode',A*Ys  + NonLinTerm(Ys) + B*Us,'p',Us);
opts = struct('tf',1.5/50);
Fn = integrator('F', 'idas', dae,opts);
U0 = ZerosControl(idyn);
sol = Fn( 'x0',InitialConditionFcn(xline),'p',U0);
Yfree = full(sol.xf);
%%
clf
xline08 = [tspan*0+0.8];
Ysol_withbonda = [xline08 ;Yfree;xline08];
surf(Ysol_withbonda)
%
%% Create Optimal Control Problem
%
YT = 0.8 + 0*xline';
eps = dx^4;
PathCost  = Function('L'  ,{ts,Ys,Us},{ Us.'*Us  });
FinalCost = Function('Psi',{Ys}      ,{ 1/(2*eps)*((Ys-YT).'*(Ys-YT)) });

iocp = ocp(idyn,PathCost,FinalCost);
iocp.TargetState = YT;
%%
U0 = ZerosControl(idyn)+2;
[OptControl ,OptState]  = ArmijoGradient(iocp,U0,'MaxIter',100);

%[OptControl ,OptState]  = IpoptSolver(iocp,U0);
%%
subplot(3,1,1)
surf(OptState)
title('Dynamics')
subplot(3,1,2)
surf(OptControl)
title('Control')
subplot(3,1,3)
surf(Yfree)
title('Free')

%%

