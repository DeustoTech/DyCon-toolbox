function btn_gm_see_callback(obj,event,h)
%BTN_GM_SEE_CALLBACK Summary of this function goes here
%   Detailed explanation goes here
%%
Y0 = h.EstimationInitialCondition;
idyn = h.dynamics;
Nx = h.grid.Nx;
Ny = h.grid.Ny;

xms = h.grid.xms;
yms = h.grid.yms;
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


%delete(h.SourcePlot)
%h.SourcePlot =    plotsources(ax,h.Sources);

isurf = h.surf_estimation;
isurf.ZData =  Ysh;

ax.XLim = ax.XLim;
ax.YLim = ax.YLim;





for it = 2:length(newtspan)
    Ysh = reshape(inewYsh(it,:)',Nx,Ny);
    isurf.ZData =  Ysh;
    isurf.Parent.Title.String = "time = " + num2str((1/newtspan(end))*newtspan(it),'%.2f') ;
    pause(0.1) 
end

pause(3.5)
Ysh = reshape(Y(1,:)',Nx,Ny);
isurf.ZData =  Ysh;
isurf.Parent.Title.String = "time = " + num2str(10*newtspan(1),'%.2f') ;

end

