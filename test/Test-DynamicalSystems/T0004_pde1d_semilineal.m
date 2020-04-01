clear all;close all
import casadi.*

Nt = 30;
Nx = 30;
T = 2;
L = 1.0;
xmesh = linspace(-L,L,Nx);
tspan = linspace(0,T,Nt);

Ys = SX.sym('x',Nx,1);
Us = SX.sym('u',Nx,1);
ts = SX.sym('t');

A = FDLaplacian(xmesh);
B = BInterior(xmesh,-0.5,0.5);
%
NonLinearTerm = Function('NLT',{Ys},{2*sin(pi*Ys/L)});
%
isys = semilinearpde1d(Ys,Us,A,B,NonLinearTerm,tspan,xmesh);

isys.InitialCondition = cos(0.5*pi*xmesh'/L);
Sol = solve(isys,ZerosControl(isys)+0);


close all
surf(Sol)