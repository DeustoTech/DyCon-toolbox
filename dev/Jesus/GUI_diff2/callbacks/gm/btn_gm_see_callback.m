function btn_gm_see_callback(obj,event,h)
%BTN_GM_SEE_CALLBACK Summary of this function goes here
%   Detailed explanation goes here
%%
Y0 = h.InitialCondition;
idyn = h.dynamics;
Nx = h.grid.Nx;
Ny = h.grid.Ny;
Sources = h.Sources;
xmin = h.grid.xmin;
xmax = h.grid.xmax;
ymin = h.grid.ymin;
ymax = h.grid.ymax;
xms = h.grid.xms;
yms = h.grid.yms;
kmax = h.kmax;
Y = h.StateVectorSolution;
Y0ms = reshape(Y0,Nx*Ny,1); 
idyn.InitialCondition = Y0ms;

ax = h.axes.EstimationGraphs;



u = xms;
v = yms;
%quiver(h.axes.EvolutionGraphs,xms,yms,u,v)


%%
pause(0.5)    

Y = h.EstimationSolution;

newtspan = linspace(idyn.tspan(1),idyn.tspan(end),50);
inewYsh = interp1(idyn.tspan,Y,newtspan);


Ysh = reshape(Y(1,:)',Nx,Ny);


delete(ax.Children)

plotsources(ax,h.Sources)
isurf = surf(xms,yms,Ysh,'Parent',ax);

ax.XLim = ax.XLim;
ax.YLim = ax.YLim;

%quiver(ax,xms,yms,cos(0.5*pi*xms),sin(0.5*pi.*yms))
shading interp;colormap jet
caxis(ax,[0 0.5*kmax])

view(ax , 0,-90)
%colorbar(h.axes.EvolutionGraphs)
axis(ax,'off')
shading(ax,'interp')
colormap(ax,'jet')


for it = 2:length(newtspan)
    Ysh = reshape(inewYsh(it,:)',Nx,Ny);
    isurf.ZData =  Ysh;
    isurf.Parent.Title.String = "time = " + num2str((1/newtspan(end))*newtspan(it),'%.2f') ;
    pause(0.1) 
end

pause(4)
Ysh = reshape(Y(1,:)',Nx,Ny);
isurf.ZData =  Ysh;
isurf.Parent.Title.String = "time = " + num2str(10*newtspan(1),'%.2f') ;

end

