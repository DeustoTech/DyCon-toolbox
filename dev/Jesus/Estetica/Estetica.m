close all
clear all
fig = figure;

scale = 1.5;
Y = scale*9.125;
X = scale*7.25;
set(fig, 'Units', 'Inches', 'Position', [0, 0,Y, X], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
%
fig.MenuBar = 'none';
%%
fig.Color = [0 0 0];
%%
ax = axes('unit','norm','pos',[0 0 1 1],'Parent',fig,'Color','w');
ax.YAxis.Color = 'w';
ax.XAxis.Color = 'w';
xlim(ax,[0 1]);
ylim(ax,[0 1]);
%%
l1 = xline(1/3,'Color',0.9*[1 1 1]);
l2 = xline(2/3,'Color',0.9*[1 1 1]);

%%
N = 40;
Colors = jet(N);
xmesh = -0.1:0.001:1.1;
for iter = 1:N
line1 = line(xmesh,xmesh,'Color',Colors(iter,:));
%%
line1.LineWidth = 1.0;
line1.YData = 0.1*sin(20*pi*xmesh).^2 + 0.1*sin(5*pi*xmesh + iter).^2;
end
%%

