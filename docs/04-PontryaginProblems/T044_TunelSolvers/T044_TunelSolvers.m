
%% Tunel Solver Neos Server AMPL - IPOPT

%%
%% Semi-linear semi-discrete heat equation and collective behavior
%%
% Definition of the time 
clear 
% Discretization of the space
N = 10;
L = 1;
xi = 0; xf = L;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
%%
Y = SymsVector('y',N);
U = SymsVector('u',1);
%%
% We create the functional that we want to minimize
% Our goal is to set the system to zero penalizing the norm of the control
% by a parameter $\beta$ that will be small.
YT = 0.2 + 0*xline';
dx = xline(2) - xline(1);
%%
% Diffusion part: the discretization of the 1d Laplacian
A = FDLaplacian(xline);
B = (N^2/L^2)*[1 ; zeros(N-2,1) ;1];
%%
%%
% Putting all the things together
Fsym  = A*Y + B*U;
syms t
Fsym_fh = matlabFunction(Fsym,'Vars',{t,Y,U,sym.empty});
%%
odeEqn = pde(Fsym_fh,Y,U);
odeEqn.InitialCondition = 0.99+0*xline';
odeEqn.Nt=20;
odeEqn.FinalTime = 2;
odeEqn.mesh{1} = xline;

%%
% We create the object that collects the formulation of an optimal control problem  by means of the object that describes the dynamics odeEqn, the functional to minimize Jfun and the time horizon T
%%
symPsi  = @(T,Y) (YT - Y).'*(YT - Y);
symL    = @(t,Y,U) 0 ;

iCP1 = Pontryagin(odeEqn,symPsi,symL);
%
iCP1.Constraints.MaxControl = 1;
iCP1.Constraints.MinControl = 0;

%%
AMPLFile(iCP1,'Domenec.txt')
out = SendNeosServer('Domenec.txt');

data = NeosLoadData(out);
%%
% The control function inside the control region
figure;
surf(data.State)

%%