clear all
T = 500;
q = normrnd(0,1,1,20);
%%
ns = [10 50 100 150];

iter = 0;
for ieps = ns
   iter = iter +1;
   reward{iter} = nuniform(q,T,ieps);
end

%%
figure(1)
clf
color = jet(length(ns));
iter = 0;

for ieps = ns
    iter = iter + 1;
    %line(1:T,cumsum(reward{iter})./(1:T),'color',color(iter,:))
    line(1:T,cumsum(reward{iter}),'color',color(iter,:))

end
title('Cumulative Reward')
xlabel('iterations')
ylabel('$r_t$','Interpreter','latex','FontSize',20)
eleg = strcat(repmat('n = ',(length(ns)),1),num2str(ns','%.0f'));
legend(eleg)