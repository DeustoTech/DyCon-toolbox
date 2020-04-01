function animation_FLD(ssline,Data,xline)
%% Graphs 


FontSize = 40;
FontSizeaxis = 25;
N = length(xline);
Nt = length(Data(1).Y(:,1));
fig = figure('unit','norm','pos',[0 0 1 1],'Color',[0 0 0]);
ax  = axes('Parent',fig,'Color',[0 0 0]);
ax.XColor = 'w';
ax.YColor = 'w';
ax.ZColor = 'w';
ax.YAxis.FontSize = FontSizeaxis;
ax.XAxis.FontSize = FontSizeaxis;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
view(ax,45,45)
iter = 0;
zlim([0 1])
xlabel(ax,'s-fractional order')
ylabel(ax,'space')
ax.ZAxis.Visible = 'off';
yticks(ax,[])
xticks(ax,[0 0.2 0.4 0.6 0.8 1])
Nss = length(ssline);

Color = 0.7*jet(Nss);

text = annotation('textbox',[0.4 0.85 0.4 0.1],'String','Fractional Laplacian','Color','w','interp','latex','FontSize',FontSize,'LineStyle','none');
%text = annotation('textbox',[0.42 0.78 0.3 0.1],'String','$u_t  + (-\Delta)^s u = 0$','Color','w','interp','latex','FontSize',FontSize,'LineStyle','none');
for s = ssline
    iter = iter + 1;
    lines(iter) = line(s*ones(1,N),xline,Data(iter).Y(1,:),'Parent',ax,'Color',Color(iter,:),'LineWidth',2);
end


%%
ang = 20;
for it = 1:floor(Nt/4)
    ang = ang + 0.06;
    view(ax,ang,20)
    pause(0.02)
end
%%
for it = 1:Nt-1
    iter = 0;
    for s = ssline
        iter = iter + 1;
        lines(iter).ZData = Data(iter).Y(it,:);
    end
    ang = ang + 0.06;

    view(ax,ang,20)
    pause(0.01)
end
end

