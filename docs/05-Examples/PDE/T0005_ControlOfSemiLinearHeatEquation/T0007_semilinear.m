%%
close all
clear all
import casadi.*
%%
% Definition of the time 
% Discretization of the space
N = 30;

%%
[A,B] = GetABmatrix(N);
%%
% we define symbolically the vectors of the state and the control
%%
ts = SX.sym('t');
Ys = SX.sym('y',[N 1]);
Us = SX.sym('u',[2 1]);
%%

%%
%%
% Definition of the non-linearity
% $$ \partial_y[-5\exp(-y^2)] $$
%%
G = casadi.Function('NLT',{Ys},{-10*Ys.*exp(-Ys.^2)/N^2 });%  
%%
% Creation of the ODE object
% Time horizon
%%
T = 120  ;Nt = 50;
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
%%
% We create the object that collects the formulation of an optimal control problem  by means of the object that describes the dynamics odeEqn, the functional to minimize Jfun and the time horizon T
%%
L   = Function('L'  ,{ts,Ys,Us},{ Us.'*Us  });
Psi = Function('Psi',{Ys}      ,{ 1e4*(Ys.'*Ys) });

iocp = ocp(idyn,L,Psi);
%%
% We apply the steepest descent method to obtain a local minimum (our functional might not be convex).
U0 =ZerosControl(idyn);
[OptControl ,OptState]  = IpoptSolver(iocp,U0);

%%
clf
plotSHE(OptState,OptControl,Yfree,tspan,Nt,N)
