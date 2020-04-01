function [reward,actions] = UniformEE(qdistri,T,N)

%%
[~, K] = size(qdistri);
%%
qdisti_est = repmat({zeros},K,1);
reward = zeros(1,T);
actions = zeros(1,T);

%% Exploration
for it = 1:N
    kchoice = randi(K);
    p = qdistri(it,kchoice);
    actions(it) = kchoice;
    reward(it) = randsample([1 0],1,true,[p 1-p]);
    % save reward in this round
    qdisti_est{kchoice}(end+1) = reward(it);
    
end
% Compute average reward
qdisti_est = arrayfun(@(i)mean(i{:}) ,qdisti_est);
% Choose the arm with the highest average reward
[~ , kmax] = max(qdisti_est);

%% Explotation
for it = (N+1):T
    actions(it) = kmax;
    p = qdistri(it,kmax);
    reward(it) = randsample([1 0],1,true,[p 1-p]);
end
%%

end

