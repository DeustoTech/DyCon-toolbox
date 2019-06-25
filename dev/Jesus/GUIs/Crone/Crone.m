clear all

g = 9.8;


xf = +5;
yf = -5;
%

%%
[xline_1 ,yline_1 ] = xyrect(xf,yf);
[xline_2 ,yline_2 ] = xyqua(xf,yf);
[xline_3 ,yline_3 ] = xyciclo(xf,yf);

%%

[xline_1,yline_1,tline_1] = CroneSolveDynamics(xline_1,yline_1,xf,yf);
[xline_2,yline_2,tline_2] = CroneSolveDynamics(xline_2,yline_2,xf,yf);
[xline_3,yline_3,tline_3] = CroneSolveDynamics(xline_3,yline_3,xf,yf);


%%
figure('unit','norm','Position',[0.2 0.1 0.6 0.8])

line([0 xf], [0 yf],'LineStyle','none','LineWidth',3,'Color','r','Marker','p')

%
line(xline_1, yline_1,'LineStyle','-','LineWidth',1,'Color','k','Marker','none')
line(xline_2, yline_2,'LineStyle','-','LineWidth',1,'Color','k','Marker','none')
line(xline_3, yline_3,'LineStyle','-','LineWidth',1,'Color','k','Marker','none')

axis('off')

hold on
% Create the mesh of shere
[X,Y,Z] = sphere; radius = 0.1;
X = X*radius; Y = Y*radius; Z = Z*radius;
% create the sphere object
isurf_1 = surf(X,Y,Z,'FaceLighting','gouraud');
isurf_2 = surf(X,Y,Z,'FaceLighting','gouraud');
isurf_3 = surf(X,Y,Z,'FaceLighting','gouraud');

daspect([1 1 1])
shading interp
lightangle(45,45)
xlim([-0.5 5.5])
ylim([-5.5 0.5])
%% choose max time 
T = max([tline_1(end) tline_2(end) tline_3(end)]);
tline = linspace(0,T,100);
%% interpolation
XY = interp1(tline_1,[xline_1 yline_1],tline);
xline_1 = XY(:,1);yline_1 = XY(:,2);
%
XY = interp1(tline_2,[xline_2 yline_2],tline);
xline_2 = XY(:,1);yline_2 = XY(:,2);
%
XY = interp1(tline_3,[xline_3 yline_3],tline);
xline_3 = XY(:,1);yline_3 = XY(:,2);
%%
gif('animation_crone.gif','DelayTime',1/11) % <= to create gif

for t = 1:length(tline)
    % change the sphere position

    isurf_1.XData = X + xline_1(t);
    isurf_1.YData = Y + yline_1(t);
    %
    isurf_2.XData = X + xline_2(t);
    isurf_2.YData = Y + yline_2(t);
    %   
    isurf_3.XData = X + xline_3(t);
    isurf_3.YData = Y + yline_3(t);
    %
    gif('frame',isurf_1.Parent)
    %
   %pause(0.05)
end

