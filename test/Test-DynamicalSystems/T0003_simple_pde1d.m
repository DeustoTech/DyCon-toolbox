function T0003_simple_pde1d

import casadi.*

Nt = 200;
Nx = 20;
T = 1;
L = 1.0;
xmesh = linspace(-L,L,Nx);
tspan = linspace(0,T,Nt);

Ys = SX.sym('x',Nx,1);
Us = SX.sym('u',Nx,1);
ts = SX.sym('t');

A = FDLaplacian(xmesh);
B = BInterior(xmesh,-0.5,0.5);

Fs =  A*Ys + B*Us + 2*sin(pi*Ys/L) ;
%
isys = pde1d(Fs,ts,Ys,Us,tspan,xmesh);
isys.InitialCondition = sin(pi*xmesh'/L);
Sol = solve(isys,ZerosControl(isys)+0);


