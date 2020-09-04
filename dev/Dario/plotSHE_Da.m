function plotSHE_Da(OptState,OptControl,Yfree,tspan,Nt,N,Z)

figure
subplot(1,3,1)
surf(Yfree','MeshStyle','col','LineWidth',1.5);
hold on
colormap jet
plot3(1:N,ones(N,1),Yfree(:,1),'ko','MarkerSize',5,'MarkerFaceColor','g')
plot3(1:N,Nt*ones(N,1),Yfree(:,end),'ko','MarkerSize',5,'MarkerFaceColor','g')
plot3(1:N,Nt*ones(N,1),Z,'ko','MarkerSize',5,'MarkerFaceColor','r')

title('Free Dynamics')
xlabel('space')
ylabel('Time')



subplot(1,3,2)
surf(OptState','MeshStyle','col','LineWidth',1.5)
title('Controlled Dynamics')
xlabel('Time')

hold on
colormap jet
plot3(1:N,ones(N,1),OptState(:,1),'ko','MarkerSize',5,'MarkerFaceColor','g')
plot3(1:N,Nt*ones(N,1),OptState(:,end),'ko','MarkerSize',5,'MarkerFaceColor','g')
plot3(1:N,Nt*ones(N,1),Z,'ko','MarkerSize',5,'MarkerFaceColor','r')

%%
% The control function inside the control region
subplot(1,3,3)

%surf(OptControl','EdgeColor','none')
plot(OptControl')

title('Control')
xlabel('space')
ylabel('Time')

%hold on 
%plot3(ones(Nt,1),1:Nt,OptControl(1,:),'LineWidth',4,'Color','k')
%plot3(1+ones(Nt,1),1:Nt,OptControl(2,:),'LineWidth',4,'Color','k')

end

