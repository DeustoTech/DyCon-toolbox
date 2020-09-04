function [InitialObservation, LoggedSignal] = myResetFunction()
% Reset function to place custom cart-pole environment into a random
% initial state.

X0 = -1;
% Xdot
Xd0 = -1;

% Return initial environment state variables as logged signals.
LoggedSignal.State = [X0;Xd0];
InitialObservation = LoggedSignal.State;

end
