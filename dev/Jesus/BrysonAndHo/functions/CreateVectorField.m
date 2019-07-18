function [quiverObj ax] = CreateVectorField(UV)

fig = figure;

XLimits = [-200 200];
YLimits = [-60  60];

XL = XLimits(2) - XLimits(1);
YL = YLimits(2) - YLimits(1);

xl = linspace(XLimits(1),XLimits(2),200);
yl = linspace(YLimits(1),YLimits(2),50);
%
[xms ,yms] = meshgrid(xl,yl);
factor = 10;

UVms = UV(xms,yms);
ums = factor*UVms(:,  1:200 );
vms = factor*UVms(:, 201:end);

hold on
modulems = sqrt(ums.^2 + vms.^2);
surf(xms,yms,-1e5+modulems,'LineStyle','none','FaceColor','interp');

quiverObj = quiver(xms,yms,ums,vms,'Color','white');
ax = quiverObj.Parent;
ax.XLim = XLimits;
ax.YLim = YLimits;
daspect(ax,[1 1 1])
hold off
end

