A = [-1 0;
      0 -4];

B = [1;0];
%
tspan = linspace(0,1,100);
%%
idyn = linearode(A,B,tspan);
idyn.InitialCondition = [1;2];

U0 = ZerosControl(idyn);
xt = solve(idyn,U0);

plot(xt')