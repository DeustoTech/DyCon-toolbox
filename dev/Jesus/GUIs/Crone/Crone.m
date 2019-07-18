clear all
SaveVideo = true;
if SaveVideo
Video = VideoWriter('Crone.avi');
Video.Quality = 100;
open(Video)
end

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
ifig = figure('unit','norm','Position',[0 0 1 1]);
ifig.Color = [0 1 0];

%line([0 xf], [0 yf],'LineStyle','none','LineWidth',3,'Color','r','Marker','p')

%
% line(xline_1, yline_1,'LineStyle','-','LineWidth',1,'Color','k','Marker','none')
% line(xline_2, yline_2,'LineStyle','-','LineWidth',1,'Color','k','Marker','none')
% line(xline_3, yline_3,'LineStyle','-','LineWidth',1,'Color','k','Marker','none')

%%
ax = axes;


axis('off')

hold on
% Create the mesh of shere
[X,Y,Z] = sphere; radius = 0.1;
X = X*radius; Z = Z*radius;
% create the sphere object
Y1 = Y*radius - 1;
isurf_1 = surf(X,Y1,Z,'FaceLighting','gouraud');
Y2 = Y*radius - 2;
%
isurf_2 = surf(X,Y2,Z,'FaceLighting','gouraud');
%
Y3 = Y*radius - 3;
isurf_3 = surf(X,Y3,Z,'FaceLighting','gouraud');

shading interp
lightangle(45,45)
lightangle(-45,45)

% xlim([-0.5 5.5])
% ylim([-5.5 0.5])
%%
rampa_1= rampa(xline_1,yline_1,radius,1,ax);
rampa_2= rampa(xline_2,yline_2,radius,2,ax);
rampa_3= rampa(xline_3,yline_3,radius,3,ax);
%%
view(10,10)
%% choose max time 
T = max([tline_1(end) tline_2(end) tline_3(end)]);
tline = linspace(0,T,300);
%% interpolation
XY = interp1(tline_1,[xline_1 yline_1],tline,'linear','extrap');
xline_1 = XY(:,1);yline_1 = XY(:,2);
xline_1(xline_1>=5) = xf;
yline_1(xline_1>=5) = yf;

%
XY = interp1(tline_2,[xline_2 yline_2],tline,'linear','extrap');
xline_2 = XY(:,1);yline_2 = XY(:,2);
xline_2(xline_2>=5) = xf;
yline_2(xline_2>=5) = yf;

%
XY = interp1(tline_3,[xline_3 yline_3],tline,'linear','extrap');
xline_3 = XY(:,1);yline_3 = XY(:,2);
xline_3(xline_3>=5) = xf;
yline_3(xline_3>=5) = yf;
%%
% f1 = fopen('bola1.txt','w');
% fprintf(f1,'%6.6f %6.6f %6.6f\n',[tline',xline_1,yline_1]')
% fclose(f1)
% %%
% f2 = fopen('bola2.txt','w');
% fprintf(f2,'%6.6f %6.6f %6.6f\n',[tline',xline_2,yline_2]')
% fclose(f2)
% %%
% f3 = fopen('bola3.txt','w');
% fprintf(f3,'%6.6f %6.6f %6.6f\n',[tline',xline_3,yline_3]')
% fclose(f3)
%%
%return
%gif('animation_crone.gif','DelayTime',1/11) % <= to create gif
daspect([1 1 1])
xlim([-1 6])
ylim([-4 1])
zlim([-6 1])

az = 10;
for t = 1:length(tline)
    % change the sphere position

    isurf_1.XData = X + xline_1(t);
    isurf_1.ZData = Z + yline_1(t) + radius;
    %
    isurf_2.XData = X + xline_2(t);
    isurf_2.ZData = Z + yline_2(t) + radius;
    %   
    isurf_3.XData = X + xline_3(t);
    isurf_3.ZData = Z + yline_3(t) + radius;
    %
    %gif('frame',isurf_1.Parent)
    %
    az = az + 0.1;
    view(az,10)
    if SaveVideo
        writeVideo(Video,getframe(ifig));
    else
        pause(2*dpause)
    end
end

for t = 1:100
    % change the sphere position

    az = az + 0.1;
    view(az,10)
    if SaveVideo
        writeVideo(Video,getframe(ifig));
    else
        pause(2*dpause)
    end
end
    if SaveVideo
        close(Video);

    end
