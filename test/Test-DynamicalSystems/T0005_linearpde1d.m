clear all;
import casadi.*

Nt = 100;
Nx = 100;
T = 1;
L = 1;
xmesh = linspace(-L,L,Nx+2);
xmesh = xmesh(2:end-1);
%
tspan = linspace(0,T,Nt);

A = FDLaplacian(xmesh);
B = BInterior(xmesh,-0.5,0.5);
%
isys = linearpde1d(A,B,tspan,xmesh);
isys.InitialCondition = sin(pi*xmesh'/L);
Sol = solve(isys,ZerosControl(isys));
%%
surf(Sol)