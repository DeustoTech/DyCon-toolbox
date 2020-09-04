%% Create a DDPG Agent
% Create a DDPG agent with actor and critic and obtain its observation and action 
% specifications.

% load predefined environment
env = rlPredefinedEnv("SimplePendulumWithImage-Continuous");

% get observation and specification info
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
%% 
% Create a critic representation.

% create a network to be used as underlying critic approximator
hiddenLayerSize1 = 400;
hiddenLayerSize2 = 300;

imgPath = [
    imageInputLayer(obsInfo(1).Dimension,'Normalization','none','Name',obsInfo(1).Name)
    convolution2dLayer(10,2,'Name','conv1','Stride',5,'Padding',0)
    reluLayer('Name','relu1')
    fullyConnectedLayer(2,'Name','fc1')
    concatenationLayer(3,2,'Name','cat1')
    fullyConnectedLayer(hiddenLayerSize1,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(hiddenLayerSize2,'Name','fc3')
    additionLayer(2,'Name','add')
    reluLayer('Name','relu3')
    fullyConnectedLayer(1,'Name','fc4')
    ];
dthetaPath = [
    imageInputLayer(obsInfo(2).Dimension,'Normalization','none','Name',obsInfo(2).Name)
    fullyConnectedLayer(1,'Name','fc5','BiasLearnRateFactor',0,'Bias',0)
    ];
actPath =[
    imageInputLayer(actInfo(1).Dimension,'Normalization','none','Name','action')
    fullyConnectedLayer(hiddenLayerSize2,'Name','fc6','BiasLearnRateFactor',0,'Bias',zeros(hiddenLayerSize2,1))
    ];

criticNetwork = layerGraph(imgPath);
criticNetwork = addLayers(criticNetwork,dthetaPath);
criticNetwork = addLayers(criticNetwork,actPath);
criticNetwork = connectLayers(criticNetwork,'fc5','cat1/in2');
criticNetwork = connectLayers(criticNetwork,'fc6','add/in2');
%%
% set some options for the critic
criticOptions = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1);

% create the critic based on the network approximator
critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,...
    'Observation',{'pendImage','angularRate'},'Action',{'action'},criticOptions);
%% 
% Create an actor representation.

% create a network to be used as underlying actor approximator
imgPath = [
    imageInputLayer(obsInfo(1).Dimension,'Normalization','none','Name',obsInfo(1).Name)
    convolution2dLayer(10,2,'Name','conv1','Stride',5,'Padding',0)
    reluLayer('Name','relu1')
    fullyConnectedLayer(2,'Name','fc1')
    concatenationLayer(3,2,'Name','cat1')
    fullyConnectedLayer(hiddenLayerSize1,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(hiddenLayerSize2,'Name','fc3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(1,'Name','fc4')
    tanhLayer('Name','tanh1')
    scalingLayer('Name','scale1','Scale',max(actInfo.UpperLimit))
    ];
dthetaPath = [
    imageInputLayer(obsInfo(2).Dimension,'Normalization','none','Name',obsInfo(2).Name)
    fullyConnectedLayer(1,'Name','fc5','BiasLearnRateFactor',0,'Bias',0)
    ];

actorNetwork = layerGraph(imgPath);
actorNetwork = addLayers(actorNetwork,dthetaPath);
actorNetwork = connectLayers(actorNetwork,'fc5','cat1/in2');

actorOptions = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);
%%
% set some options for the actor
actorOpts = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);

% create the actor based on the network approximator
actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'pendImage','angularRate'},'Action',{'scale1'},actorOptions);

%% 
% Specify agent options, and create a PG agent using the environment, actor, 
% and critic.

agentOpts = rlDDPGAgentOptions(...
    'SampleTime',env.Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e6,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',32);
agent = rlDDPGAgent(actor,critic,agentOpts);
%% 
% To check your agent, use getAction to return the action from a random observation.

maxepisodes = 5000;
maxsteps = 500;
trainingOptions = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',-740);


trainingStats = train(agent,env,trainingOptions);
