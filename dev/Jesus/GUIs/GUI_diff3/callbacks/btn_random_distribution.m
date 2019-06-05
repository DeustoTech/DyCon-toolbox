function btn_solve_dyn_callback(obj,eve,h)
%BTN_SOLVE_DYN_CALLBACK Summary of this function goes here
%   Detailed explanation goes here

idyn  = h.dynamics;
dx    = h.grid.dx;
xmin  = h.grid.xmin; xmax  = h.grid.xmax;
ymin  = h.grid.ymin; ymax  = h.grid.ymax;

xms   = h.grid.xms;  yms   = h.grid.yms;
Nx    = h.grid.Nx; Ny = h.grid.Ny;

alpha = 0.5*dx;

Y0 = 0*xms;

xminSource =  xmin; xmaxSource = xmax;
yminSource =  ymin; ymaxSource = ymax;

Nsource = abs(normrnd(10,2)) + 1;

for is = 1:Nsource
    
    nopass = true;
    while nopass
        y0 =  xminSource + (xmaxSource-xminSource).*rand(1,1);
        x0 =  yminSource + (ymaxSource-yminSource).*rand(1,1);
        if is > 1
            dist = sqrt((y0 - [Sources.y0]).^2 + (x0 - [Sources.x0]).^2);
            mindist = min(dist);
            if mindist < 2*dx
                nopass = true;
            else
                nopass = false;
            end
        else
            nopass = false;
        end
    end
    k = normrnd(100,10);
    
    Y0   = Y0 + k*exp(-((xms-x0).^2  + (yms-y0).^2)/alpha^2);
    % save Soruces
    Sources(is).x0 = x0;
    Sources(is).y0 = y0;
end

% mesh -> vector
Y0vector = reshape(Y0,Nx*Ny,1); 

h.Sources            =  Sources;
h.InitialCondition   =  Y0vector;

idyn.InitialCondition = Y0vector;
[~ ,Y] = solve(idyn);
h.Solution       = Y;
h.FinalCondition = Y(end,:)';
       

%% Graphs Final Polution


h.surf_evolution.ZData  = reshape(h.FinalCondition,Nx,Ny) ;
h.surf_estimation.ZData = h.surf_evolution.ZData*0;
delete(h.SourcePlot)



end

