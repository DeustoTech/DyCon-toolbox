function btn_gm_callback(obj,event,h)
%BTN_GM_CALLBACK Summary of this function goes here
%   Detailed explanation goes here

xms  = h.grid.xms;
yms = h.grid.yms;
xline = h.grid.xline;
yline = h.grid.yline;
dx    = h.grid.dx;
xmin  = h.grid.xmin;
xmax  = h.grid.xmax;
ymin  = h.grid.ymin;
ymax  = h.grid.ymax;
Nx    = h.grid.Nx;
Ny    = h.grid.Ny;
Y     = h.StateVectorSolution;
idyn = h.dynamics;
A = h.matrix.A;
V = h.matrix.V;
kmax = h.kmax;
%%
h.stop_gm = false;

    adjoint = copy(idyn);
    adjoint.dt = 2*adjoint.dt;
    adjoint.A = idyn.A - V;
    YT = Y(end,:);
    Y0_iter = 0.0*Y(1,:)';
    Y0_iter_ms = reshape(Y0_iter,Nx,Ny);

    %
    delete(h.axes.EstimationGraphs.Children)
    isurf = surf(xms,yms,Y0_iter_ms,'Parent',h.axes.EstimationGraphs);
    shading(h.axes.EstimationGraphs,'interp');
    colormap jet
    caxis(h.axes.EstimationGraphs,[0 kmax])
    view(0,-90)
    %colorbar
    axis(h.axes.EstimationGraphs,'off')
    hold on

    LengthStep = 1;
    
    idyn.InitialCondition = Y0_iter;
    [~ , Yiter ] = solve(idyn);
    adjoint.InitialCondition = Yiter(end,:) - YT;
    
    for iter = 1:100
        
    idyn.InitialCondition = Y0_iter;
    [~ , Yiter ] = solve(idyn);
    adjoint.InitialCondition = Yiter(end,:) - YT;


    [~ , Piter ] = solve(adjoint);
    Piter = flipud(Piter);

    
    
    Y0_iter = Y0_iter - LengthStep*Piter(1,:)';
    Y0_iter(Y0_iter<0) = 0;
    Y0_iter = 0.95*Y0_iter + 0.05*Y(1,:)';


    if mod(iter,1) == 0
    Y0_iter_ms = reshape(Y0_iter,Nx,Ny);
    isurf.ZData =  Y0_iter_ms;
    isurf.Parent.Title.String = "Iter = "+iter;
    %x= xms;y = yms; a = Y0_iter_ms;

    %lMaxInd = localMaximum(a,1000); 
    %lMaxInd = FastPeakFind(a);

    %[ypeaks ylocks ] = arrayfun(@(iy) findpeaks(Y0_iter_ms(:,iy)),1:Ny,'UniformOutput',false);
    %[xpeaks xlocks ] = arrayfun(@(ix) findpeaks(Y0_iter_ms(ix,:)),1:Nx,'UniformOutput',false);



    if exist('pm')
        delete(pm)
    end 
    %pm = plot3(x(lMaxInd),y(lMaxInd),0*a(lMaxInd),'ko','markersize',10,'linewidth',1.5); 

    pause(0.1)
    if h.stop_gm 
        h.EstimationInitialCondition = Y0_iter;
        h.EstimationSolution = Yiter;
        h.stop_gm  = false;
        isurf.Parent.Title.String = "Solution";

        return
    end

    end
    end


end

