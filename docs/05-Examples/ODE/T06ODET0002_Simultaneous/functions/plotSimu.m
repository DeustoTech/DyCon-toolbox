function plotSimu(tspan,Yfree,Ycontrol,OptControl_1,M)

%%
options = {'FontSize',13,'Interpreter','latex'};
%%
color1 = jet(M);
color2 = jet(M);
% set labels 
subplot(2,3,1);
title('Free ',options{:})
xlabel('t',options{:})
ylabel('$x_1^\nu$',options{:})
%ylim([-0.2 2])
%
subplot(2,3,4);
title('Free',options{:})
xlabel('t',options{:})
ylabel('$x_2^\nu$',options{:})
%ylim([-2 5])
%
subplot(2,3,2);
title('Controlled',options{:})
xlabel('t',options{:})
ylabel('$x_1^\nu$',options{:})
%ylim([-0.2 2])
%
subplot(2,3,5);
title('Controlled',options{:})
xlabel('t',options{:})
ylabel('$x_2^\nu$',options{:})
%ylim([-2 5])

%% Free dynamics
for i = 1:M
    subplot(2,3,1);
    line(tspan,Yfree(2*(i-1)+1,:),'Color',color1(i,:))

    subplot(2,3,4);
    line(tspan,Yfree(2*i,:),'Color',color2(i,:))
end
%% State with Control
for i = 1:M
    subplot(2,3,2);
    line(tspan,Ycontrol(2*(i-1)+1,:),'Color',color1(i,:))
    %
    subplot(2,3,5);
    line(tspan,Ycontrol(2*i,:),'Color',color2(i,:))
end

%% Control
subplot(1,3,3)
plot(tspan,OptControl_1)
ylabel('u(t)',options{:})
xlabel('t',options{:})
title('Control',options{:})

end

