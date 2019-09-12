N = 100;
Nt = 150;
ssline = linspace(0.01,0.99,16);

xi = -1; xf = 1;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
M = MassMatrix(xline);
a = -0.3; b = 0.8;
B = BInterior(xline,a,b,'Mass',true);

FinalTime = 0.6;
Y0 =cos(pi*xline');
Y0(xline > 0.2) = 0
Y0(xline < -0.2) = 0

s = 0.5;
A = -FEFractionalLaplacian(s,1,N);
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'Nt',Nt);
dynamics.mesh = xline;
dynamics.MassMatrix = M;

iter = 0;
for s = ssline
    iter = iter + 1;
    A = -FEFractionalLaplacian(s,1,N);
    dynamics.A = A;
    [tspan,Ysolution] = solve(dynamics);
    Data(iter).Y = Ysolution;
end
%% Graphs 
fig = figure('Color',[0 0 0]);
ax  = axes('Parent',fig,'Color',[0 0 0]);
ax.XColor = 'w'
ax.YColor = 'w'
ax.ZColor = 'w'
view(ax,45,45)
iter = 0;
zlim([0 1])
xlabel(ax,'s')
ylabel(ax,'space')
ax.ZAxis.Visible = 'off'
yticks(ax,[])
Nss = length(ssline)

Color = jet(Nss);


text = annotation('textbox',[0.35 0.8 0.3 0.1],'String','$u_t = -(\nabla^2)^s u$','Color','w','interp','latex','FontSize',20,'LineStyle','none');
for s = ssline
    iter = iter + 1;
    lines(iter) = line(s*ones(1,N),xline,Data(iter).Y(1,:),'Parent',ax,'Color',Color(iter,:),'LineWidth',2);
end


%%
ang = 20;
for it = 1:100
    angT = ang + 10*(it/50);
    view(ax,angT,20)
    pause(0.1)
end
ang = angT;
%%
for it = 1:Nt-1
    iter = 0;
    for s = ssline
        iter = iter + 1;
        lines(iter).ZData = Data(iter).Y(it,:);
    end
    ang = ang + it*0.001;

    view(ax,ang,20)
    pause(0.05)
end

