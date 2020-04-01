
% Bernoulli distribution
qdistri = [0.1 0.3 0.4 0.1 0.8];

iuser = user(qdistri);

%%
T = 50; 
K = length(qdistri);
%%
qdistri_est = repmat({zeros},K,1);
reward = zeros(1,T);
for it = 1:T
    e = (it).^(-1/3);
    
        success = randsample([1 0],1,true,[e 1-e]);
    
    if success
        % Exploration
        kchoice = randi(K);
    else
        % Explotation
        qdistri_est_current = arrayfun(@(i)mean(i{:}) ,qdistri_est);
        [~ , kchoice] = max(qdistri_est_current);
    end
    p = qdistri(kchoice);

    reward(it) = randsample([1 -1],1,true,[p 1-p]);
    % save reward in this round
    qdistri_est{kchoice}(end+1) = reward(it);  
end
%%
plot(cumsum(reward)./(1:T))
hold on