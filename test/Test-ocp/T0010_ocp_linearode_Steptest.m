clear all;close all
import casadi.*
%

iocp = P0001_OCProblem;

idyn = iocp.DynamicSystem;
U0 = ZerosControl(idyn);
FreeState = solve(idyn,U0);
tspan = idyn.tspan;

ControlGuess = ZerosControl(idyn);
[OptControl ,OptState] = SteptestGradientDescent(iocp,ControlGuess);

%%
figure
subplot(1,2,1);
plot(tspan,OptState');
title('Optimal State')
ylim([-1 2])
subplot(1,2,2);
plot(tspan,FreeState')
title('Free')
ylim([-1 2])
