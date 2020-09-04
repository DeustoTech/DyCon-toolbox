%% Train Custom LQR Agent
% This example shows how to train a custom linear quadratic regulation (LQR) 
% agent to control a discrete-time linear system modeled in MATLAB®.
%% Create Linear System Environment
clear all 

dt = 0.1;

A = -eye(3);
 %
B = [1.0 ,0.0 ,0.0; ...
     0.0 ,1.0 ,0.0; ...
     0.0 ,0.0 ,1.0]; 
%% 
% The quadratic cost matrices are: 
% 
% $$\begin{array}{l}Q=\left\lbrack \begin{array}{ccc}10 & 3 & 1\\3 & 5 & 4\\1 
% & 4 & 9\end{array}\right\rbrack \\R=\left\lbrack \begin{array}{ccc}0\ldotp 5 
% & 0 & 0\\0 & 0\ldotp 5 & 0\\0 & 0 & 0\ldotp 5\end{array}\right\rbrack \end{array}$$

Q = [10,3,1;3,5,4;1,4,9]; 
R = 0.5*eye(3);
%% 
env = myDiscreteEnv(A,B,Q,R,dt);
%% 
K0 = eye(3);
%% 
% To create a custom agent, you must create a subclass of the |rl.agent.CustomAgent| 
% abstract class. For the custom LQR agent, the defined custom subclass is |LQRCustomAgent|. 
% For more information, see <docid:rl_ug#mw_a8922397-ab65-458d-a307-eaf44d7241de 
% Custom Agents>. Create the custom LQR agent using $Q$, $R$, and $K_0$. The agent 
% does not require information on the system matrices $A$ and $B$. 

agent = LQRCustomAgent(Q,R,K0);

%% 
% For this example, set the agent discount factor to one. To use a discounted 
% future reward, set the discount factor to a value less than one.
agent.EstimateNum = 45;
agent.Gamma = 1;
%% 
% Because the linear system has three states and three inputs, the total number 
% of learnable parameters is $m=21$. To ensure satisfactory performance of the 
% agent, set the number of parameter estimates $N_p$ to be greater than twice 
% the number of learnable parameters. In this example, the value is $N_p =45$.


%% Train Agent
%%
[Koptimal,P] = dlqr(A,B,Q,R); 

%%
trainingOpts = rlTrainingOptions(...
    'MaxEpisodes',1, ...
    'MaxStepsPerEpisode',2, ...
    'Verbose',false, ...
    'Plots','none');
%% 
% Train the agent using the <docid:rl_ref#mw_c0ccd38c-bbe6-4609-a87d-52ebe4767852 
% |train|> function. 

simOptions = rlSimulationOptions('MaxSteps',5);

Nt = 100;
xt = zeros(3,Nt);

xt(:,1) = env.LoggedSignals;
for i = 2:Nt
    %
    %trainingStats = train(agent,env,trainingOpts);
    experience    = sim(env,agent,simOptions);
    %
    xt(:,i) = experience.Observation.obs1.Data(:,:,end);
    %
    fprintf("K = "+num2str(norm(agent.K-Koptimal))+"\n"); 
end

%%

figure(1)
plot(xt','o-')
