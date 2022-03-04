function T0005_linearpde1d

import casadi.*

Nt = 50;
Nx = 50;
T = 0.1;
L = 1;
xmesh = linspace(-L,L,Nx+2);
xmesh = xmesh(2:end-1);
%
tspan = linspace(0,T,Nt);
ts = casadi.SX.sym('ts');

A = FDLaplacian(xmesh);
B = BInterior(xmesh,-0.5,0.5);
%
isys = linearpde1d(A,B,ts,tspan,xmesh);
isys.InitialCondition = sin(pi*xmesh'/L);
Sol = solve(isys,ZerosControl(isys));
%%
