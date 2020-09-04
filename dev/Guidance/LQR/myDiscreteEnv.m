function env = myDiscreteEnv(A,B,Q,R,dt)
% This function creates a discrete-time linear system environment.
%
% (A,B) are the system matrices, where dx = Ax + Bu.
% (Q,R) defines the quadratic cost, where r = x'Qx + u'Ru.

% Copyright 2018-2019 The MathWorks Inc.

% observation info
OINFO = rlNumericSpec([size(A,1),1]);
% action info
AINFO = rlNumericSpec([size(B,2),1]);
% environment
env = rlFunctionEnv(OINFO,AINFO,...
    @(action,loggedSignals) myStepFunction(action,loggedSignals,A,B,Q,R,dt),@() myResetFunction(Q));

end

function [Observation, Reward, IsDone, LoggedSignals] = myStepFunction(Action,LoggedSignals,A,B,Q,R,dt)
% This is the step function for the environment, which returns the next
% observation for a given action.
% observations
x = LoggedSignals;
% dynamics
dx = x + dt*(A*x+B*Action);
Observation = dx;
LoggedSignals = dx;
% isDone
IsDone = false; 
% Reward
Reward = -dt*(x'*Q*x -Action'*R*Action);
end

function [InitialObservation, LoggedSignals] = myResetFunction(Q)
% This is the reset function for the environment, which sets random initial
% conditions for the observation.
n = size(Q,1);
x0 = ones(n,1);
InitialObservation = x0;
LoggedSignals=InitialObservation;
end
