function aniGuidance(YO_tline,N,M,u_t)
zz = YO_tline;

uePlot = zz(:,1:2*N);

uePx = uePlot(:,1:2:2*N);
uePy = uePlot(:,2:2:2*N);
 plot(uePx,uePy,'-','Color',[1 0.7 0.7])
 hold on
% 
vePlot = zz(:,4*N+1:4*N+2*M);
% 
vePx = vePlot(:,1:2:2*M);
vePy = vePlot(:,2:2:2*M);
% 
plot(vePx,vePy,'-','Color',[0.7 0.7 1])


lv = plot(vePx(1,:),vePy(1,:),'bo');
hold on
lu = plot(uePx(1,:),uePy(1,:),'ro');

xmin = min(min([uePx(:);vePx(:)]));
xmax = max(max([uePx(:);vePx(:)]));
ymin = min(min([uePy(:);vePy(:)]));
ymax = max(max([uePy(:);vePy(:)]));

xmin = min([xmin u_t(1)]);
xmax = max([xmax u_t(1)]);
ymin = min([ymin u_t(2)]);
ymax = max([ymax u_t(2)]);

xlim([xmin xmax])
ylim([ymin ymax])

[TN,~ ]= size(YO_tline);


plot(u_t(1),u_t(2),'gp','MarkerSize',10)
plot(u_t(1),u_t(2),'go','MarkerSize',10)

daspect([1 1 1])
for it = 1:2:TN-1
    lv.XData = vePx(it,:);lv.YData = vePy(it,:);
    lu.XData = uePx(it,:);lu.YData = uePy(it,:);
    pause(0.1)
end
end

