clear all
T = 1000;
q = normrnd(0,1,1,50);
%%

c = 2;
reward{1} = UCB(q,T,c);
reward{2} = eGreedy(q,T,0.1);
reward{3} = eGreedy(q,T,0.7);

%%
iter = 0;
figure(1)
clf
line(1:T,cumsum(reward{1}),'color','b')
line(1:T,cumsum(reward{2}),'color','g')
line(1:T,cumsum(reward{3}),'color','r')
title('Cumulative Reward')
xlabel('iterations')
ylabel('$r_t$','Interpreter','latex','FontSize',20)
legend({'UCB','\epsilon = 0.1','\epsilon = 0.7'})

