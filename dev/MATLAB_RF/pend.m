clear 
mdl = 'rlSimplePendulumModel';
env = rlPredefinedEnv('SimplePendulumModel-Discrete');
%%
env.getObservationInfo
%%
env.getActionInfo
%% 
env.ResetFcn = @(in)setVariable(in,'theta0',pi,'Workspace',mdl);
%% 
%% Create DQN agent
statePath = [
    imageInputLayer([3 1 1],'Normalization','none','Name','state')
    fullyConnectedLayer(24,'Name','CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(48,'Name','CriticStateFC2')];
actionPath = [
    imageInputLayer([1 1 1],'Normalization','none','Name','action')
    fullyConnectedLayer(48,'Name','CriticActionFC1','BiasLearnRateFactor',0)];
commonPath = [
    additionLayer(2,'Name','add')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(1,'Name','output')];
%
criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');
%% 
figure
plot(criticNetwork)
%% 
criticOptions = rlRepresentationOptions('LearnRate',0.01,'GradientThreshold',1);
%% 

states_obj  = getObservationInfo(env);
control_obj = getActionInfo(env);
%
critic = rlQValueRepresentation(criticNetwork,states_obj,control_obj,...
                                'Observation',{'state'},'Action',{'action'},criticOptions);
%%  Agent
Ts = 0.1; 

agentOptions = rlDQNAgentOptions(...
    'SampleTime',Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',3000,... 
    'UseDoubleDQN',true,...
    'DiscountFactor',0.9,...
    'MiniBatchSize',64);
%% 
agent = rlDQNAgent(critic,agentOptions);

%% 

trainingOptions = rlTrainingOptions(...
    'MaxEpisodes',1000,...
    'MaxStepsPerEpisode',200,...
    'ScoreAveragingWindowLength',5,...
    'Verbose',true,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',-1100,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',-1100);

doTraining = false;

if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainingOptions);
    
else
    % Load pretrained agent for the example.
    load('/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/MATLAB_RF/savedAgents/Agent22.mat')
end
%
%% Simulate DQN Agent

simOptions = rlSimulationOptions('MaxSteps',500);
experience = sim(env,agent,simOptions);
%% 
% _Copyright 2019 The MathWorks, Inc._