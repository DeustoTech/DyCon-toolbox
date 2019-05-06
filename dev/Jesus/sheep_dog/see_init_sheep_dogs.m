function see_init_sheep_dogs(ax,file)
%SEE_INIT_SHEEP_DOGS Summary of this function goes here
%   Detailed explanation goes here

plot_target = plot_target_sd(ax,file);

load(file)

ax.XLim = [-10 10];
ax.YLim = [-10 10];


blue = [0 0 1];
sblue = 0.1*blue + 0.9*[1 1 1]; 

red = [1 0 0];
sred = 0.1*red + 0.9*[1 1 1]; 

%%

%%

for k = 1:M_d
	point_dog(k) = line(ud(1,1,k),ud(2,1,k),'LineStyle','none','Marker','o','MarkerSize',8,'Parent',ax,'Color',blue,'MarkerFaceColor',sblue);
end

for k = 1:M_e
	point_sheep(k) = line(ue(1,1,k),ue(2,1,k),'LineStyle','none','Marker','o','MarkerSize',8,'Parent',ax,'Color',red,'MarkerFaceColor',sred);
end


legend(ax,[point_sheep(1) point_dog(1) plot_target],'Sheep','Dogs','Target','FontSize',12)

end

