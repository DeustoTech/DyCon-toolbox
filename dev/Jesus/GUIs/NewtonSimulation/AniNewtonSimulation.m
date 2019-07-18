%% Pause 
dpause = 0.025;
SaveVideo = true;
BackgroundColor = [0 1 0];
%% Define mesh 

XLim = [-20 20];
YLim = [-20 20];
%
xline = linspace(XLim(1),XLim(2),50);
yline = linspace(YLim(1),YLim(2),50);
%
[xms ,yms] = meshgrid(xline,yline);
zms = Vfh(xms,yms);
%%
ifig = figure(1);
ifig.MenuBar='none';
ifig.ToolBar='none';
if SaveVideo
Video = VideoWriter('myfile.avi');
Video.Quality = 100;
open(Video)
end
ifig.Units = 'norm';
ifig.Position = [0 0 1 1];
clf
delete(ifig.Children);
ifig.Color = BackgroundColor;
hold on

%% Surface Solid 
solidsurf = surf(xms,yms,zms,'FaceLighting','gouraud','FaceColor','interp');
solidsurf.MeshStyle = 'none';
axis(solidsurf.Parent,'off')

% fixed Limits of Graphs
solidsurf.Parent.XLim = XLim;
solidsurf.Parent.YLim = YLim;
solidsurf.Parent.ZLim = solidsurf.Parent.ZLim;

xl = xlim()
yl = ylim()
zl = zlim()
hold on;
line(0.5*xl, [0,0], [0,0], 'LineWidth', 1, 'Color', 'w');
line([0,0], 0.5*yl, [0,0], 'LineWidth', 1, 'Color', 'w');
line([0,0], [0,0], 0.5*zl, 'LineWidth', 1, 'Color', 'w');
%%
lightangle(165,73)
daspect([1 1 1])
%% Text 
itext = annotation(ifig,'textbox','String','$f(x,y) = x^2-y^2$','FontSize',40,'Interpreter','latex');
itext.Color = 'w';
itext.BackgroundColor = 'none';
itext.Units = 'norm';
itext.LineStyle = 'none';
itext.Position = [0.4 0.8 0.2 0.1];
%% Animation Surface
Azint = 145;
Elint = 38;
Azend = 180;
Elend = 0;

Az = Azint;
El = Elint; 

view(Az,El)

MaxIter = 200;
for it = 1:MaxIter
    Az = Azint + (Azend-Azint)*(it/MaxIter);
    El = Elint + (Elend-Elint)*(it/MaxIter);
    view(Az,El)
    if SaveVideo
        writeVideo(Video,getframe(ifig));
    else
        pause(2*dpause)
    end
end
%%
Azint = Azend;
Elint = Elend;
Azend = 0;
Elend = 0;

Az = Azint;
El = Elint; 

view(Az,El)

MaxIter = 300;
for it = 1:MaxIter
    Az = Azint - (Azend-Azint)*(it/MaxIter);
    El = Elint + (Elend-Elint)*(it/MaxIter);
    view(Az,El)
    if SaveVideo
        writeVideo(Video,getframe(ifig));
    else
        pause(2*dpause)
    end
end

%% Create Graphs Objects
x = StateSolution(1,1);
y = StateSolution(1,2);
radius = 1;
z = Vfh(x,y) + radius;
% Create the mesh of shere
[Xs,Ys,Zs] = sphere;
X = (Xs+x)*radius; Y = (Ys+y)*radius; Z = (Zs+z)*radius;
% create the sphere object
isurf = surf(X,Y,Z,'FaceLighting','gouraud','FaceColor','interp');
% set color of sphere
isurf.CData = isurf.CData*0 + 1;
%
isurf.MeshStyle = 'none';

%%
for it = 1:30
    if SaveVideo
        writeVideo(Video,getframe(ifig));
    else
        pause(2*dpause)
    end
end

%% Create Line 
l1 = line(x,y,z,'Color','red','LineWidth',4);
%% Create animation

% gif('animation.gif','DelayTime',1/11) % <= to create gif
for it = 1:2:dynamics.Nt
    % change the sphere position
    %
    x = StateSolution(it,1);
    y = StateSolution(it,2);
    z = Vfh(x,y) + radius;
    %
    X = (Xs+x)*radius; Y = (Ys+y)*radius; Z = (Zs+z)*radius;

    isurf.XData = X;
    isurf.YData = Y;
    isurf.ZData = Z;
    % change the Azimutal Angle in 0.1 degree
    Az = Az + 0.05;
    El = El + 0.1;
    view(isurf.Parent,Az,El)
    %
    l1.XData = [l1.XData x];
    l1.YData = [l1.YData y];
    l1.ZData = [l1.ZData z];

    % pause for see the update graphs 
    if SaveVideo
        writeVideo(Video,getframe(ifig));
    else
        pause(2*dpause)
    end
    % get frame of figure
    % gif('frame',isurf.Parent) % <== to create gif
    % stop animation when the potential is very high
    if abs(Vfh(StateSolution(it,1),StateSolution(it,2))) > 1e6
        break
    end
end


    if SaveVideo
        close(Video);

    end
