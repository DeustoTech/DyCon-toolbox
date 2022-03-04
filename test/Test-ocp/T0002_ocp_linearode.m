function T0002_ocp_linearode

import casadi.*
%
A = [-2  1;
      1 -2];

B = [1 0;
     0 1];
%
ts = casadi.SX.sym('ts');

tspan = linspace(0,1,10);
idyn = linearode(A,B,ts,tspan);
idyn.InitialCondition = [1;2];

Control0  = ZerosControl(idyn);
FreeState = solve(idyn,Control0);


%
[ts,Xs,Us] = symvars(idyn);

PathCost  = Us'*Us           ;
FinalCost = 1e4*(Xs'*Xs) ;

iocp = ocp(idyn,PathCost,FinalCost);


ControlGuess = ZerosControl(idyn);
[OptControl ,OptState] = ClassicalGradient(iocp,ControlGuess);

%%
figure
subplot(1,2,1);
plot(tspan,full(OptState'));
title('Optimal State')
ylim([-1 2])
subplot(1,2,2);
plot(tspan,full(FreeState'))
title('Free')
ylim([-1 2])
