clear
% Bernoulli distribution
q =  normrnd(0,1,1,10);

%%
T = 2000; 
%%
reward_e00 = greedy(q,T,0.0);
reward_e05 = greedy(q,T,0.5);
reward_e07 = greedy(q,T,0.7);
reward_e09 = greedy(q,T,0.9);

%
clf
plot(cumsum(reward_e00)./(1:T),'-')
hold on
plot(cumsum(reward_e05)./(1:T),'-')
plot(cumsum(reward_e07)./(1:T),'-')
plot(cumsum(reward_e09)./(1:T),'-')

legend({'e=0.0','e=0.5','e=0.7','e=0.9'})

function reward = greedy(q,T,e)
    K = length(q);
    qec = zeros(1,K);
    reward = zeros(1,T);
    for it = 1:T
        %
        if rand > e
            % Exploration
            kchoice = randi(K);
        else
            % Explotation    
            %
            [maxq] = max(qec);
            %
            indexq = 1:length(qec);
            %
            kchoice = indexq(qec == maxq);
            %
            if length(kchoice) > 1
                kchoice = kchoice(randi(length(kchoice)));
            end
            %
        end
        p = q(kchoice);

        reward(it) = p;
        % save reward in this round
        alpha = 1;
        qec(kchoice) = qec(kchoice) + alpha*(reward(it)-qec(kchoice));

        %qec(kchoice) = qec(kchoice) + (1/it)*(reward(it)-qec(kchoice));
    end

end 