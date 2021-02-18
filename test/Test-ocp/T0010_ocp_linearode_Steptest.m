function T0010_ocp_linearode_Steptest

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