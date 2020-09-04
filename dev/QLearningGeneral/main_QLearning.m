%%
close all
clear all
import casadi.*
%%
N = 100;
L = 1.0;
xmesh = linspace(-L,L,N);

A = FDLaplacian(xmesh);
% add Neumann
A(1,2)       = 2*A(1,2);
A(end,end-1) = 2*A(end,end-1);
% Need some Matrix control
B = BInterior(xmesh,-0.5,0.5);
%%
% we define symbolically the vectors of the state and the control
%%
ts = SX.sym('t');
Ys = SX.sym('y',[N 1]);
Us = SX.sym('u',[N 1]);
%%
% Definition of the non-linearity
% $$ \partial_y[-5\exp(-y^2)] $$
%%
Theta = 1/3;
G = Function('G',{Ys},{Ys.*(1-Ys).*(Ys-Theta)});
%%
% Creation of the ODE object
% Time horizon
%%
T = 6  ;Nt = 50;
tspan = linspace(0,T,Nt);
%
xi = 0; xf = 1;
xline = linspace(xi,xf,N);
idyn = semilinearpde1d(Ys,Us,A,B,G,tspan,xline);

% Initial condition
Y0 = sin(pi*xline');

idyn.InitialCondition = Y0;
%%
% We solve the equation and we plot the free solution applying solve to odeEqn and we plot the free solution.
%%
Yfree = solve(idyn,ZerosControl(idyn));
Yfree = full(Yfree);
%%
% We create the object that collects the formulation of an optimal control problem  by means of the object that describes the dynamics odeEqn, the functional to minimize Jfun and the time horizon T
%%
L   = Function('L'  ,{ts,Ys,Us},{ Us.'*Us  });
Psi = Function('Psi',{Ys}      ,{ 1e4*(Ys.'*Ys) });

iocp = ocp(idyn,L,Psi);
%%
Ymax = 1; Ymin = 0;
limits = [Ymin*ones(N,1) ,Ymax*ones(N,1)];

Ns = 100;


