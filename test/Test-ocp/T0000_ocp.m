function T0000_ocp
import casadi.*

Xs = SX.sym('x',3,1); % State
Us = SX.sym('u',2,1); % Control
ts = SX.sym('t');     % time

%
A = [ -2.0 +1.0  +1.0  ;
      +1.0 -2.0  +0.1  ;
      +1.0 +0.1  -4.0  ];
%%%%%%
B = [1 0 ;
     0 1 ;
     0 1];
%% Dynamics
F = A*Xs + B*Us ;
%F = casadi.Function('F',{ts,Xs,Us},{F});
%
tspan = linspace(0,2,50);
%
idyn = ode(F,ts,Xs,Us,tspan);
idyn.InitialCondition = [1;2;1];

%%
Control0  = ZerosControl(idyn);
FreeState = solve(idyn,Control0);

%%
% Cost Function 
PathCost  = 1e-1*(Us'*Us);
FinalCost = 0 ;
%

% Inequality Path Constraint
IPC = - Us;
% Inequality End Constraint
IEC = [];
% Equality Path Constraint
EPC = [];
% Equality End Constraints
EEC = Xs;
%
%%
iocp = ocp(idyn,PathCost,FinalCost,'EqualityPathConstraint'   , EPC , ...
                                   'EqualityEndConstraint'    , EEC , ...
                                   'InequalityPathConstraint' , IPC , ...
                                   'InequalityEndConstraint'  , IEC);
%
%%
ControlGuess = ZerosControl(idyn);

[OptControl ,OptState] = IpoptSolver(iocp,ControlGuess);

%%
subplot(2,1,1)
plot(full(OptState)')
subplot(2,1,2)
plot(full(OptControl)')