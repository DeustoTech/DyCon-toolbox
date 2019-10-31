iter = 0;
ss = [0.3 0.4 0.6 0.8];
for is = ss
    iter = iter + 1;
   result{iter} = s2state(is);
end

%%

fig = figure('unit','norm','pos',[0 0 1 1],'Color','k');
ax  = axes('Parent',fig,'Color','none');
ax.XAxis.FontSize = 25;
ax.YAxis.FontSize = 25;
ax.XAxis.Color = 'none';
ax.YAxis.Color = 'none';

xticks([])
yticks([])
ylim([-7 7])
LW = 3;
Color = cool(length(ss));
xline = linspace(-1,1,length(result{iter}(1,:)));
for  iter = 1:length(ss)
    lS(iter) = line(xline,result{iter}(1,:),'LineWidth',LW,'Color',Color(iter,:),'Parent',ax,'Marker','none','MarkerSize',15);
end

lg1 = legend([repmat('s = ',length(ss),1) num2str(ss')],'Color','w','FontSize',25,'FontWeight','bold');
lg1.Location = 'northeastoutside';

    pause(0.1)

for it = 1:length(result{iter}(:,1))
    for  iter = 1:length(ss)
        lS(iter).YData = result{iter}(it,:);
    end

    pause(0.1)
end