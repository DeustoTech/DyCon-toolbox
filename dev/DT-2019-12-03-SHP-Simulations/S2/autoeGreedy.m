function [reward] = autoeGreedy(q,T)
%%
    K = length(q);
    qdistri_est = repmat({[]},K,1);
    reward = zeros(1,T);
    for it = 1:T
        e = 1/it^(1/3);
        %
        if rand > e
            % Exploration
            kchoice = randi(K);
        else
            % Explotation
            qec = arrayfun(@(i)mean(i{:}) ,qdistri_est);
            %
            qec(isnan(qec)) = 0;
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
        end
        p = q(kchoice);

        reward(it) = p + normrnd(0,1);
        % save reward in this round
        qdistri_est{kchoice}(end+1) = reward(it);  
    end

end

