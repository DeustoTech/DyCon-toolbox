
max_state = +3;
min_state = -3;

max_control = +3;
min_control = -3;

state   = rlNumericSpec([2 1],'UpperLimit',max_state,'LowerLimit',min_state);
action = rlNumericSpec([1],'UpperLimit',max_control,'LowerLimit',min_control);
%action = rlFiniteSetSpec({-1,0,1});
%%
env = rlFunctionEnv(state,action,@myStepFunction,@myResetFunction);

Nt = 500;

state_time = zeros(2,Nt);
rt = zeros(1,Nt);

for it = 1:Nt
   [state_time(:,it),rt(it),IsDone2,LoggedSignals2] = step(env,0);
end
%%
% B = @(state,action) [state(1)^2    + state(2)^2            ; ...
%                      state(1) + exp(action) ; ...
%                      abs(action)            ; ...
%                      state(2)];
% W0 = [1;4;4;2];
% %
% critic = rlQValueRepresentation({B,W0},state,action);
% %
% v = getValue(critic,{[1  3]'},{[5]'});
% %
% opt = rlDQNAgentOptions;
% 
% agent =  rlDQNAgent(critic,opt);
% %
% trainOpts = rlTrainingOptions(...
%     'MaxEpisodes',5000,...
%     'MaxStepsPerEpisode',100,...
%     'Verbose',true,...
%     'Plots','none',...
%     'StopTrainingCriteria','AverageReward',...
%     'StopTrainingValue',100);
% %
% trainingStats = train(agent,env,trainOpts);


%%
hiddenLayerSize = 10; 
numObs = 2;
numAct = 1;
observationPath = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(hiddenLayerSize,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(hiddenLayerSize,'Name','fc2')
    additionLayer(2,'Name','add')
    reluLayer('Name','relu2')
    fullyConnectedLayer(hiddenLayerSize,'Name','fc3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(1,'Name','fc4')];
actionPath = [
    imageInputLayer([numAct 1 1],'Normalization','none','Name','action')
    fullyConnectedLayer(hiddenLayerSize,'Name','fc5')];

% create the layerGraph
criticNetwork = layerGraph(observationPath);
criticNetwork = addLayers(criticNetwork,actionPath);

% connect actionPath to obervationPath
criticNetwork = connectLayers(criticNetwork,'fc5','add/in2');
%
criticOptions = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1);
%
critic = rlQValueRepresentation(criticNetwork,state,action,...
    'Observation',{'observation'},'Action',{'action'},criticOptions);
%%
actorNetwork = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(numAct,'Name','fc4')
    tanhLayer('Name','tanh1')];

actorOptions = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);

actor = rlDeterministicActorRepresentation(actorNetwork,state,action,...
    'Observation',{'observation'},'Action',{'tanh1'},actorOptions);

Ts = 0.05;
agentOptions = rlDDPGAgentOptions(...
    'SampleTime',Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e6 ,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',256);
agentOptions.NoiseOptions.Variance = 1e-1;
agentOptions.NoiseOptions.VarianceDecayRate = 1e-6;

agent = rlDDPGAgent(actor,critic,agentOptions);

maxepisodes = 1000;

Tf = 5;
maxsteps = ceil(Tf/Ts);
trainingOptions = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'StopOnError',"on",...
    'Verbose',false,...
    'Plots',"training-progress",...
    'StopTrainingCriteria',"AverageReward",...
    'StopTrainingValue',415,...
    'ScoreAveragingWindowLength',10,...
    'SaveAgentCriteria',"EpisodeReward",...
    'SaveAgentValue',415); 


    trainingStats = train(agent,env,trainingOptions);
%%
simOptions = rlSimulationOptions('MaxSteps',Nt);
experience = sim(env,agent,simOptions);
%%
subplot(2,1,1)
plot(experience.Action.act1)
subplot(2,1,2)
plot(experience.Observation.obs1)

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

Reward = exp(-norm(X-1).^2)/100;


end
