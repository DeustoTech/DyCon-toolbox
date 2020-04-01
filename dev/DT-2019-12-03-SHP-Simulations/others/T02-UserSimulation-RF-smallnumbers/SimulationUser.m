clear all;
%%
Nq = 3;
Ne = 4;
Nt = 200;
%%
%b = [0.9 0.5 0.9]';
b = rand(Nq,1);
b(1)   = 0.1;
b(2)   = 0.4;
b(3)   = 0.9;
%%
%%
%ut = randi(Nq,Ne,Nt-1);
ut = zeros(Ne,Nt-1);

%% simulation
xt = zeros(Ne,Nt);
x0 = ones(Ne,1);
xt(:,1) = x0;

for it = 2:Nt
    xt(:,it) = fdynamics(xt(:,it-1),ut(:,it-1),b);
end
%%
Rfcn = @(x) sum(x);
%% Calculate size of Action Space and 
%% Obtain all posible state and acctions 
%
R = arrayfun(@(i) Rfcn(states{i}),1:length(states))';
Q = sparse(1000,1000);

%% Parameters of Algorithm - Q-Learning
epsilon = 0.9;
epsilonDecay = 0.95; % Decay factor per iteration.
epsilonmin = 1e-2;

learnRate = 0.6;
discount = 0.8;
% Simulation Parameters
Nt = 100;
ut = zeros(Ne,Nt-1);
xt = zeros(Ne,Nt);
x0 = zeros(Ne,1);
xt(:,1) = x0;

for it = 2:Nt
    %% PICK AN ACTION 
    % 
    sIdx = find(arrayfun(@(i) norm(states{i}-xt(:,it-1)) == 0 ,1:length(states)),1);
    if (rand()>epsilon)
        [~,aIdx] = max(Q(sIdx,:)); % Pick the action the Q matrix thinks is best!
    else
        aIdx = randi(length(actions),1); % Random action!
    end
    % Simulate Dynamics 
    ut(:,it-1) = actions{aIdx}; 
    xt(:,it) = fdynamics(xt(:,it-1),ut(:,it-1),b);
    % Obtain index of new state
    snewIdx = find(arrayfun(@(i) norm(states{i}-xt(:,it)) == 0 ,1:length(states)),1);
    % Update Q-matrix
    Q(sIdx,aIdx) = Q(sIdx,aIdx) + learnRate * ( R(snewIdx) + discount*max(Q(snewIdx,:)) - Q(sIdx,aIdx) );
    % Dacay probability of exploration
    if epsilon > epsilonmin
        epsilon = epsilon*epsilonDecay;
    else
        epsilon = epsilonmin;
    end
end

%%

histog = arrayfun(@(i) histcounts(ut(:,i),0:Nq)',1:Nt-1,'UniformOutput',false);
histog = [histog{:}];
%%
clf
plot(histog','o-')
xlabel('time steps')
ylabel('Number of articles')
legend(strcat(repmat('P(q_',Nq,1),num2str((0:Nq-1)'),')=',num2str(b,'%.2f')))
yticks([0:Ne])
%%
clf
plot(sum(xt),'.-','MarkerSize',10)
hold on 
plot(smoothdata(sum(xt),'SmoothingFactor',0.94),'-','LineWidth',4)
yticks([0:Ne])
xlabel('time steps')
ylabel('Number of articles')
title('r_t = sum(x_t)')
