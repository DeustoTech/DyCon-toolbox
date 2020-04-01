function [reward,actions] = eGreedyEE(qdistri,T)
%EGREEDYEE Summary of this function goes here
%   Detailed explanation goes here

%%
[~, K] = size(qdistri);
%%
qdistri_est = repmat({zeros},K,1);
reward = zeros(1,T);
actions = zeros(1,T);

for it = 1:T
    e = 0.5;
    success = randsample([1 0],1,true,[e 1-e]);
    
    if success
        % Exploration
        kchoice = randi(K);
    else
        % Explotation
        qdistri_est_current = arrayfun(@(i)mean(i{:}) ,qdistri_est);
        [~ , kchoice] = max(qdistri_est_current);
    end
    p = qdistri(it,kchoice);
    actions(it) = kchoice;

    reward(it) = randsample([1 0],1,true,[p 1-p]);
    % save reward in this round
    qdistri_est{kchoice}(end+1) = reward(it);  
end
%%
end

