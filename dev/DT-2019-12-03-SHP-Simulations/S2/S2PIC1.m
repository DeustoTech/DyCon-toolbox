clear all
T = 1000;
q = normrnd(0,1,1,50);
%%
eps = [0.0 0.3 0.5 0.9];

iter = 0;
for ieps = eps
   iter = iter +1;
   reward{iter} = eGreedy(q,T,ieps);
end

%%
iter = 0;
figure(1)
clf
color = jet(length(eps)+1);
for ieps = eps
    iter = iter + 1;
    line(1:T,cumsum(reward{iter}),'color',color(iter,:))
end
title('Cumulative Reward')
xlabel('iterations')
ylabel('$r_t$','Interpreter','latex','FontSize',20)
eleg = strcat(repmat('\epsilon = ',length(eps),1),num2str(eps','%.2f'));
eleg = cellstr(eleg);
legend(eleg)