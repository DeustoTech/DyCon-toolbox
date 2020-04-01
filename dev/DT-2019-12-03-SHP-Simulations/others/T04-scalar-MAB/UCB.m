
% Bernoulli distribution
q =  normrnd(0,1,1,10);

%%
T = 2000; 
K = length(q);
%%
qdistri_est = repmat({[]},K,1);
reward = zeros(1,T);
e = 0.1;
for it = 1:T
    %e = (it).^(-1/3);
    success = randsample([1 0],1,true,[e 1-e]);
    
    if success
        % Exploration
        kchoice = randi(K);
    else
        % Explotation
        %qd_nt = arrayfun(@(i)length(i{:}) ,qdistri_est);
        qec = arrayfun(@(i)mean(i{:}) ,qdistri_est);
        %
        qec(isnan(qec)) = 0;
        %
        c = 2;
        [~ , kchoice] = max(qec);
    end
    p = q(kchoice);

    reward(it) = p;
    % save reward in this round
    qdistri_est{kchoice}(end+1) = reward(it);  
end
%
plot(cumsum(reward)./(1:T),'r-')
