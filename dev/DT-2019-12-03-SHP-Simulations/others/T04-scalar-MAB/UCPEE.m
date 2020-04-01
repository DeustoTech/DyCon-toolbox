function [reward,actions] = UCPEE(qdistri,T)
%UCPEE Summary of this function goes here
%   Detailed explanation goes here

% Bernoulli distribution

%
[~, K] = size(qdistri);
%%
qdistri_est = repmat({[]},K,1);
reward = zeros(1,T);
actions = zeros(1,T);

for it = 1:T
    e = 0.3;
    success = randsample([1 0],1,true,[e 1-e]);
    
    if success
        % Exploration
        kchoice = randi(K);
    else
        % Explotation
        qd_nt = arrayfun(@(i)length(i{:}) ,qdistri_est);
        qdistri_est_current = arrayfun(@(i)mean(i{:}) ,qdistri_est);
        c = 2;
        [~ , kchoice] = max(qdistri_est_current + c*sqrt(log(it)./(qd_nt+0.1)));
    end
    actions(it) = kchoice;
    p = qdistri(it,kchoice);

    reward(it) = randsample([1 0],1,true,[p 1-p]);
    % save reward in this round
    qdistri_est{kchoice}(end+1) = reward(it);  
end
%%
end

