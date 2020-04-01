
% Bernoulli distribution
qdistri = [0.1 0.3 0.4 0.1 0.5];

iuser = user(qdistri);

%%
T = 500; 
K = length(qdistri);
%%
qdisti_est = repmat({zeros},K,1);
reward = zeros(1,T);
% Exploration
N = 20;
for it = 1:N
    kchoice = randi(K);
    p = qdistri(kchoice,it);
    reward(it) = randsample([1 0],1,true,[p 1-p]);
    % save reward in this round
    qdisti_est{kchoice}(end+1) = reward(it);
    
end
% Compute average reward
qdisti_est = arrayfun(@(i)mean(i{:}) ,qdisti_est);
% Choose the arm with the highest average reward
[~ , kmax] = max(qdisti_est);
% Explotation
for it = (N+1):T
    p = qdistri(kmax,it);
    reward(it) = randsample([1 -1],1,true,[p 1-p]);
end
%%
clf
semilogx(cumsum(reward)./(1:T),'bo-')
ylim([0 1])
hold on
sum(reward)