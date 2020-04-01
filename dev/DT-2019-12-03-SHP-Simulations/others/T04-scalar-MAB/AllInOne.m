clear all
% Bernoulli distribution


%%
T = 200; 

tspan = 1:T;
qdistri = [0.3 + 0.2*sin(0.5*pi*tspan/T).^2; 
           0.9 + 0.1*cos(1*pi*tspan/T).^2;
           0.1 + 0.2*sin(1*pi*tspan/T - 0.25*pi).^2]';
%%
Nexp = 50;
rw_uniform = zeros(Nexp,T);
rw_eGreedy = zeros(Nexp,T);
rw_UCB = zeros(Nexp,T);

for iexp = 1:Nexp
    [rw_uniform(iexp,:),ac_uni]  = UniformEE(qdistri,T,1);
     [rw_eGreedy(iexp,:), ac_Gree] = eGreedyEE(qdistri,T);
     [rw_UCB(iexp,:),ac_UCB]     = UCPEE(qdistri,T);
end

%%
figure(1)
clf
plot(mean(cumsum(rw_eGreedy')')./(1:T))
hold on
plot(mean(cumsum(rw_uniform')')./(1:T))
plot(mean(cumsum(rw_UCB')')./(1:T))
legend({'Greedy','uniform','UCB'})
title('reward')
xlabel('time')
%
figure(2)
clf
plot(qdistri)
legend
xlabel('time')
