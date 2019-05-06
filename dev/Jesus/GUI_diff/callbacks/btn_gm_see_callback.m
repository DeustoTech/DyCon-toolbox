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


Y = h.EstimationSolution;
Ysh = reshape(Y(1,:)',Nx,Ny);


delete(ax.Children)
isurf = surf(xms,yms,Ysh,'Parent',ax);

u = xms;
v = yms;
%quiver(h.axes.EvolutionGraphs,xms,yms,u,v)

shading interp;colormap jet
caxis(ax,[0 kmax])

view(ax , 0,-90)
%colorbar(h.axes.EvolutionGraphs)
axis(ax,'off')
shading(ax,'interp')
colormap(ax,'jet')
%%
pause(0.5)    

for it = 2:length(idyn.tspan)
    Ysh = reshape(Y(it,:)',Nx,Ny);
    isurf.ZData =  Ysh;
    isurf.Parent.Title.String = "time = " + idyn.tspan(it) ;
    pause(0.07)
end

pause(1)
Ysh = reshape(Y(1,:)',Nx,Ny);
isurf.ZData =  Ysh;
isurf.Parent.Title.String = "time = " + idyn.tspan(1) ;

end

