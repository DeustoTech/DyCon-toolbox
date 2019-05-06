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
Sources = h.Sources;
%%
h.stop_gm = false;

    adjoint = copy(idyn);
    adjoint.dt = 2*adjoint.dt;
    adjoint.A = idyn.A - V;
    YT = Y(end,:);
    Y0_iter = 1.0*Y(end,:)';
    Y0_iter_ms = reshape(Y0_iter,Nx,Ny);

    %
    delete(h.axes.EstimationGraphs.Children)
    isurf = surf(xms,yms,Y0_iter_ms,'Parent',h.axes.EstimationGraphs);
    shading(h.axes.EstimationGraphs,'interp');
    colormap jet
    caxis(h.axes.EstimationGraphs,[0 0.5*kmax])
    view(0,-90)
    %colorbar
    axis(h.axes.EstimationGraphs,'off')
    hold on

    LengthStep = 1;
    
    idyn.InitialCondition = Y0_iter;
    [~ , Yiter ] = solve(idyn);
    adjoint.InitialCondition = Yiter(end,:) - YT;
        
    [~ , Piter ] = solve(adjoint);
    Piter = flipud(Piter);
    
    Pnorm = norm(Yiter(end,:) - YT);

    
    hd = waitbar(0,'Loading ...');
    for iter = 1:25

        
        newY0_iter = Y0_iter - LengthStep*Piter(1,:)';
        newY0_iter(newY0_iter<0) = 0; 
        idyn.InitialCondition = newY0_iter;
        [~ , newYiter ] = solve(idyn);
        adjoint.InitialCondition = newYiter(end,:) - YT;
        newPnorm = norm(Yiter(end,:) - YT);
        
        while newPnorm > Pnorm && LengthStep > 1e-3
            LengthStep = 0.5*LengthStep;
            newY0_iter = Y0_iter - LengthStep*Piter(1,:)';
            newY0_iter(newY0_iter<0) = 0; 
            idyn.InitialCondition =newY0_iter;
            [~ , newYiter ] = solve(idyn);
            adjoint.InitialCondition = newYiter(end,:) - YT;

    
            newPnorm = norm(newYiter(end,:) - YT);                           
        end
        Pnorm = newPnorm;
        LengthStep = 2*LengthStep;
        
        Yiter = newYiter;
        Y0_iter = newY0_iter;
        
        
        [~ , Piter ] = solve(adjoint);
        Piter = flipud(Piter);   
        
        Y0_iter = 0.95*Y0_iter + 0.05*Y(1,:)';
        %Y0_iter = 1*Y0_iter + 0*Y(1,:)';

        %Y0_iter(Y0_iter < 0.05*max(max(Y0_iter))) = 0;
        

        if mod(iter,2) == 0        
            waitbar(iter/25,hd)

            Y0_iter_ms = reshape(Y0_iter,Nx,Ny);
            isurf.ZData =  Y0_iter_ms;
            %isurf.Parent.Title.String = "Estimation in Iteration = "+iter;

            pause(0.1)
        end
        if Pnorm < 1
            break
        end 
    end
    
    delete(hd)
    h.EstimationInitialCondition = Y0_iter;
    h.EstimationSolution = Yiter;
    h.stop_gm  = false;
    %isurf.Parent.Title.String = "Initial Condition Estimation" ;

    plotsources(h.axes.EstimationGraphs,Sources)

end


