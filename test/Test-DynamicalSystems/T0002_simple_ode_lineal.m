function T0002_simple_ode_lineal

A = [-1 0;
      0 -4];

B = [1;0];
%
tspan = linspace(0,1,100);
ts = casadi.SX.sym('ts');
%%
idyn = linearode(A,B,ts,tspan);
idyn.InitialCondition = [1;2];

U0 = ZerosControl(idyn);
xt = solve(idyn,U0);

