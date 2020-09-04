
function [NextObs,Reward,IsDone,LoggedSignals] = myStepFunction(Action,LoggedSignals)


% Unpack the state vector from the logged signals.
State = LoggedSignals.State;

% Perform Euler integration.
dt = 0.05;
A = [0    1;
     -5 -0.5];
B = [0;1];
F = A*State + B*Action;
LoggedSignals.State = State + dt.*F;

% Transform state to observation.
NextObs = LoggedSignals.State(1:2);

% Check terminal condition.
X = NextObs(1);
IsDone = X < 1.1 && X > 0.9; 

Reward = exp(-norm(X-1).^2)/100;


end