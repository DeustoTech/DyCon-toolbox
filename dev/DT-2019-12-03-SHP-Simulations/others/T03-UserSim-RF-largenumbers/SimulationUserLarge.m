clear all;
%%
Nq = 5;
Ne = 15;
Nt = 20;
%%
%b = [0.9 0.5 0.9]';
b = rand(Nq,1);
b(1) = 0.6;
%%
%%
%ut = randi(Nq,Ne,Nt-1);
ut = 1*zeros(Ne,Nt-1);

%% simulation
xt = zeros(Ne,Nt);
x0 = ones(Ne,1);
xt(:,1) = x0;

for it = 2:Nt
    xt(:,it) = fdynamics(xt(:,it-1),ut(:,it-1),b);
end
%%
Rfcn = @(x) sum(x);
%
Q = sparse(0,0);

%%
epsilon = 0.9;
epsilonDecay = 1; % Decay factor per iteration.
learnRate = 0.9;
discount = 0.9;
%% simulation
Nt = 20;
ut = zeros(Ne,Nt-1);
xt = zeros(Ne,Nt);
x0 = zeros(Ne,1);
xt(:,1) = x0;

states = {};
for it = 2:Nt
    %% PICK AN ACTION 
    sIdx = find(arrayfun(@(i) norm(states{i}-xt(:,it-1)) == 0 ,1:length(states)),1);
    if (rand()>epsilon)
        [~,aIdx] = max(Q(sIdx,:)); % Pick the action the Q matrix thinks is best!
    else
        aIdx = randi(length(actions),1); % Random action!
    end
    
    ut(:,it-1) = actions{aIdx}; 
    
    xt(:,it) = fdynamics(xt(:,it-1),ut(:,it-1),b);
    %
    snewIdx = find(arrayfun(@(i) norm(states{i}-xt(:,it)) == 0 ,1:length(states)),1);
    %
    Q(sIdx,aIdx) = Q(sIdx,aIdx) + learnRate * ( R(snewIdx) + discount*max(Q(snewIdx,:)) - Q(sIdx,aIdx) );
    %
    epsilon = epsilon*epsilonDecay;

end

%%

histog = arrayfun(@(i) histcounts(ut(:,i),0:Nq-1)',1:Nt-1,'UniformOutput',false);
histog = [histog{:}];
%$
plot(histog','o-')
xlabel('time steps')
ylabel('Number of articles')
legend(strcat(repmat('q_',Nq,1),num2str((1:Nq)')))
