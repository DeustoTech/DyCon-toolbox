function btn_random_callback(obj,event,h)
%BTN_RAMDON_CALLBACK Summary of this function goes here
%   Detailed explanation goes here

xline = h.grid.xline;
yline = h.grid.yline;
dx    = h.grid.dx;
xmin  = h.grid.xmin;
xmax  = h.grid.xmax;
ymin  = h.grid.ymin;
ymax  = h.grid.ymax;
Nx    = h.grid.Nx;
Ny    = h.grid.Ny;


[xms,yms] = meshgrid(xline,yline);

alpha = 2*dx;

Y0 = 0*xms;


xminSource =  xmin; xmaxSource = xmax;
yminSource =  ymin; ymaxSource = ymax;
Nsource = 15;

for is = 1:Nsource
    y0 =  xminSource + (xmaxSource-xminSource).*rand(1,1);
    x0 =  yminSource + (ymaxSource-yminSource).*rand(1,1);

    k = 50;

    Y0   = Y0 + k*exp(-((xms-x0).^2  + (yms-y0).^2)/alpha^2);
    % save Soruces
    Sources(is).x0 = x0;
    Sources(is).y0 = y0;
end
h.Sources          = Sources;
h.InitialCondition = Y0;

%%
Y0ms = reshape(Y0,Nx*Ny,1); 
idyn.InitialCondition = Y0ms;

%%
delete(h.axes.InitialGraphs.Children)
line([Sources.x0],[Sources.y0],'Marker','.','LineStyle','none','MarkerSize',8,'Color','k','Parent',h.axes.InitialGraphs)
line([Sources.x0],[Sources.y0],'Marker','o','LineStyle','none','MarkerSize',10,'Color','k','Parent',h.axes.InitialGraphs)

Ysh = reshape(Y0ms,Nx,Ny);

xline_100 = linspace(xmin,xmax,100);
yline_100 = linspace(ymin,ymax,100);

[xms_100 ,yms_100] = meshgrid(xline_100,yline_100);
Ysh_100 = griddata(xms,yms,Ysh,xms_100,yms_100);
hold(h.axes.InitialGraphs,'on')
isurf = surf(xms_100,yms_100,Ysh_100,'Parent',h.axes.InitialGraphs);
shading(h.axes.InitialGraphs,'interp')
colormap(h.axes.InitialGraphs,'jet')
caxis(h.axes.InitialGraphs,[0 50])
view(h.axes.InitialGraphs, 0,-90)
colorbar(h.axes.InitialGraphs)

%%
h.grid.xms = xms;
h.grid.yms = yms;
h.kmax   = k;


end

