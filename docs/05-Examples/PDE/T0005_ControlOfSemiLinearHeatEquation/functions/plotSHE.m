function plotSHE(OptState,OptControl,Yfree,tspan,Nt,N)

figure
subplot(1,3,1)
surf(Yfree','MeshStyle','col','LineWidth',1.5);
hold on
colormap jet
plot3(1:N,ones(N,1),Yfree(:,1),'ko','MarkerSize',5,'MarkerFaceColor','g')
plot3(1:N,Nt*ones(N,1),Yfree(:,end),'ko','MarkerSize',5,'MarkerFaceColor','g')

title('Free Dynamics')
xlabel('space')
ylabel('Time')
yticks([1 Nt])
yticklabels([tspan(1) tspan(end)])


subplot(1,3,2)
surf(OptState','MeshStyle','col','LineWidth',1.5)
title('Controlled Dynamics')
xlabel('space')
ylabel('Time')
yticks([1 Nt])
yticklabels([tspan(1) tspan(end)])
hold on
colormap jet
plot3(1:N,ones(N,1),OptState(:,1),'ko','MarkerSize',5,'MarkerFaceColor','g')
plot3(1:N,Nt*ones(N,1),OptState(:,end),'ko','MarkerSize',5,'MarkerFaceColor','g')

%%
% The control function inside the control region
subplot(1,3,3)

surf(OptControl','EdgeColor','none')
title('Control')
xlabel('space')
ylabel('Time')
yticks([1 Nt])
yticklabels([tspan(1) tspan(end)])
hold on 
plot3(ones(Nt,1),1:Nt,OptControl(1,:),'LineWidth',4,'Color','k')
plot3(1+ones(Nt,1),1:Nt,OptControl(2,:),'LineWidth',4,'Color','k')

end

