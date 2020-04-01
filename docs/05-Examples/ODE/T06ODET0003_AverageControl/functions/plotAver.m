function plotAver(tspan,Yfree,Ycontrol,OptControl_1,M,N)

%%
options = {'FontSize',13,'Interpreter','latex'};
%%
color1 = jet(M);
color2 = jet(M);
% set labels 
subplot(3,3,1);
title('Free ',options{:})
xlabel('t',options{:})
ylabel('$x_1^\nu$',options{:})
xticks([tspan(1) tspan(end)])
%ylim([-0.2 2])
%
subplot(3,3,4);
title('Free',options{:})
xlabel('t',options{:})
ylabel('$x_2^\nu$',options{:})
xticks([tspan(1) tspan(end)])
%ylim([-2 5])
%
subplot(3,3,2);
title('Controlled',options{:})
xlabel('t',options{:})
ylabel('$x_1^\nu$',options{:})
xticks([tspan(1) tspan(end)])
%ylim([-0.2 2])
%
subplot(3,3,5);
title('Controlled',options{:})
xlabel('t',options{:})
ylabel('$x_2^\nu$',options{:})
xticks([tspan(1) tspan(end)])

%ylim([-2 5])

%% Free dynamics
for i = 1:M
    subplot(3,3,1);
    line(tspan,Yfree(2*(i-1)+1,:),'Color',color1(i,:))

    subplot(3,3,4);
    line(tspan,Yfree(2*i,:),'Color',color2(i,:))
end
%% State with Control
for i = 1:M
    subplot(3,3,2);
    line(tspan,Ycontrol(2*(i-1)+1,:),'Color',color1(i,:))
    %
    subplot(3,3,5);
    line(tspan,Ycontrol(2*i,:),'Color',color2(i,:))
end

%% Control
subplot(1,3,3)
plot(tspan,OptControl_1)
ylabel('u(t)',options{:})
xlabel('t',options{:})
title('Control',options{:})

%%

subplot(3,3,7)

cellstate = arrayfun(@(index) mean(Yfree(index:(M+1):N*M,:),1)',1:N,'UniformOutput',0);
meanvector = [cellstate{:}];

plot(tspan,meanvector);
legend(strcat(repmat('x_',N,1),num2str((1:N)')))
title('Free Average States',options{:})
xticks([tspan(1) tspan(end)])

%%
% Average Control
cellstate = arrayfun(@(index) mean(Ycontrol(index:(M+1):N*M,:),1)',1:N,'UniformOutput',0);
meanvector = [cellstate{:}];
subplot(3,3,8)

plot(tspan,meanvector);
legend(strcat(repmat('x_',N,1),num2str((1:N)')))
title('Control Average States',options{:})
xticks([tspan(1) tspan(end)])

end


