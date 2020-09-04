
max_state = +3;
min_state = -3;



state   = rlNumericSpec([2 1],'UpperLimit',max_state,'LowerLimit',min_state);
%
max_control = +10;
min_control = -10;
Na = 5;

actions = linspace(max_control,min_control,Na);

action   = rlFiniteSetSpec(actions);
%%
env = rlFunctionEnv(state,action,@myStepFunction,@myResetFunction);

Nt = 20;

state_time = zeros(2,Nt);
rt = zeros(1,Nt);

for it = 1:Nt
   [state_time(:,it),rt(it),IsDone2,LoggedSignals2] = step(env,0);
end
%%
B = @(state,action) [state(1)^2    + state(2)^2            ; ...
                     state(1) + exp(action) ; ...
                     abs(action)            ; ...
                     state(2)];
W0 = [1;4;4;2];
%
critic = rlQValueRepresentation({B,W0},state,action);
%
v = getValue(critic,{[1  3]'},{[5]'});
%
opt = rlDQNAgentOptions;

agent =  rlDQNAgent(critic,opt);
%
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',10,...
    'MaxStepsPerEpisode',Nt,...
    'Verbose',true,...
    'Plots','none',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',100);
%
trainOpts.UseParallel = 0;
trainingStats = train(agent,env,trainOpts);


%%
%%
simOptions = rlSimulationOptions('MaxSteps',Nt);
experience = sim(env,agent,simOptions);
%%
subplot(2,1,1)
plot(experience.Action.act1)
subplot(2,1,2)
plot(experience.Observation.obs1)
legend
%%


%%
function [NextObs,Reward,IsDone,LoggedSignals] = myStepFunction(Action,LoggedSignals)
% Custom step function to construct cart-pole environment for the function
% name case.
%
% This function applies the given action to the environment and evaluates
% the system dynamics for one simulation step.

% Define the environment constants.



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
IsDone = false;
Reward = exp(-norm(X).^2)/100;


end
