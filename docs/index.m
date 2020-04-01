%%
import casadi.*
x = SX.sym('x',[2 1]);
u = SX.sym('u',[2 1]);
t = SX.sym('t');
f = casadi.Function('f',{t,x,u},{x - x.^2 + u});
%%
T  = 2;
Nt = 100;
tspan = linspace(0,T,Nt);
%
idyn = ode(f,x,u,tspan);
idyn.InitialCondition = [2,4]';
%%
psi = casadi.Function('psi',{x}    ,{x.'*x});
L   = casadi.Function('L'  ,{t,x,u},{u.'*u});
iocp = ocp(idyn,L,psi);
%%
u0 = ZerosControl(idyn);
[uopt,xopt] = IpoptSolver(iocp,u0);