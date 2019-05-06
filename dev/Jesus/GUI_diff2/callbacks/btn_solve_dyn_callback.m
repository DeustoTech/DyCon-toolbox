function btn_solve_dyn_callback(obj,eve,h)
%BTN_SOLVE_DYN_CALLBACK Summary of this function goes here
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

alpha = 1.5*dx;

Y0 = 0*xms;


xminSource =  xmin; xmaxSource = xmax;
yminSource =  ymin; ymaxSource = ymax;

Nsource = floor(normrnd(10,2));
if isempty(Nsource)
    Nsource = 10;
    h.parameters.NSource.String = '10';
end
for is = 1:Nsource
    y0 =  xminSource + (xmaxSource-xminSource).*rand(1,1);
    x0 =  yminSource + (ymaxSource-yminSource).*rand(1,1);

    k = normrnd(80,20);

    Y0   = Y0 + k*exp(-((xms-x0).^2  + (yms-y0).^2)/alpha^2);
    % save Soruces
    Sources(is).x0 = x0;
    Sources(is).y0 = y0;
end
h.Sources          = Sources;
h.InitialCondition = Y0;

%%
Y0ms = reshape(Y0,Nx*Ny,1); 


%%
h.grid.xms = xms;
h.grid.yms = yms;
h.kmax   = k;
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

Y0ms = reshape(Y0,Nx*Ny,1); 
idyn.InitialCondition = Y0ms;

[~ ,Y] = solve(idyn);

h.StateVectorSolution = Y;

%% Graphs Final Polution


hold(h.axes.EvolutionGraphs,'on')
line([Sources.x0],[Sources.y0],'Marker','.','LineStyle','none','MarkerSize',8,'Color','k','Parent',h.axes.EvolutionGraphs)
line([Sources.x0],[Sources.y0],'Marker','o','LineStyle','none','MarkerSize',10,'Color','k','Parent',h.axes.EvolutionGraphs)

Ysh = reshape(Y(end,:)',Nx,Ny);


delete(h.axes.EvolutionGraphs.Children)
delete(h.axes.EstimationGraphs.Children)
surf([0 0;0 0],'Parent',h.axes.EstimationGraphs )
view(0,90);axis(h.axes.EstimationGraphs ,'off')

surf(xms,yms,Ysh,'Parent',h.axes.EvolutionGraphs);
caxis(h.axes.EvolutionGraphs,[0 kmax])
view(h.axes.EvolutionGraphs , 0,-90)
axis(h.axes.EvolutionGraphs,'off')
shading(h.axes.EvolutionGraphs,'interp')
colormap(h.axes.EvolutionGraphs,'jet')



end

