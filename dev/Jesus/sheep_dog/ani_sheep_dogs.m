function ani_sheep_dogs(ax,file)
%ANI_SHEEP_DOGS Summary of this function goes here
%   Detailed explanation goes here

load(file)

plot_target = plot_target_sd(ax,file);

ax.XLim = [-10 10];
ax.YLim = [-10 10];

blue = [0 0 1];
sblue = 0.2*blue + 0.8*[1 1 1]; 

red = [1 0 0];
sred = 0.2*red + 0.8*[1 1 1]; 


%%
for k = 1:M_d
	line(ud(1,1,k),ud(2,1,k),'LineStyle','none','Marker','o','LineWidth',0.1,'Parent',ax,'Color',sblue);
end
for k = 1:M_e
	line(ue(1,1,k),ue(2,1,k),'LineStyle','none','Marker','o','LineWidth',0.1,'Parent',ax,'Color',sred);
end


%%
for k = 1:M_d
	line_dog(k) =line(ud(1,1,k),ud(2,1,k),'LineStyle','-','LineWidth',0.1,'Parent',ax,'Color',sblue);
end
for k = 1:M_e
	line_sheep(k) = line(ue(1,1,k),ue(2,1,k),'LineStyle','-','LineWidth',0.1,'Parent',ax,'Color',sred);
end

for k = 1:M_d
	point_dog(k) = line(ud(1,1,k),ud(2,1,k),'LineStyle','none','Marker','o','MarkerSize',8,'Parent',ax,'Color',blue,'MarkerFaceColor',sblue);
end

for k = 1:M_e
	point_sheep(k) = line(ue(1,1,k),ue(2,1,k),'LineStyle','none','Marker','o','MarkerSize',8,'Parent',ax,'Color',red,'MarkerFaceColor',sred);
end

legend(ax,[point_sheep(1) point_dog(1) plot_target],'Sheep','Dogs','Target')

for it = 1:2:(Nt-1)
   
    for k = 1:M_d
        point_dog(k).XData = ud(1,it,k);
        point_dog(k).YData = ud(2,it,k);
        
        line_dog(k).XData = [ line_dog(k).XData ud(1,it,k)];
        line_dog(k).YData = [ line_dog(k).YData ud(2,it,k)];

    end

    for k = 1:M_e
        point_sheep(k).XData = ue(1,it,k);
        point_sheep(k).YData = ue(2,it,k);
        
        line_sheep(k).XData = [ line_sheep(k).XData ue(1,it,k)];
        line_sheep(k).YData = [ line_sheep(k).YData ue(2,it,k)];
        
    end
    
    pause(0.1)
end

end

