function btn_gm_callback(obj,event,h)
%BTN_GM_CALLBACK Summary of this function goes here
%   Detailed explanation goes here

Nx    = h.grid.Nx;
Ny    = h.grid.Ny;

YT     = h.FinalCondition;
if isempty(YT)
   errordlg('Need a Final Condition. Click in Random Distribution or Click in Left Axis') 
end

idyn = h.dynamics;
A = h.matrix.A;
V = h.matrix.V;
Sources = h.Sources;
%%

adjoint = copy(idyn);
adjoint.dt = 2*adjoint.dt;
adjoint.A = A - V;

Y0_iter = 1.0*YT;
%Y0_iter = 0.0*YT;

Y0_iter_ms = reshape(Y0_iter,Nx,Ny);

    %
h.surf_estimation.ZData = Y0_iter_ms;

    LengthStep = 1;
    
    [Pnorm , Y_iter ] = U2norm(Y0_iter);
    dJ = U2gradient(Y_iter);
    
    hd = waitbar(0,'Loading ...');
    
    MaxiIter = 300;
    for iter = 1:MaxiIter
 
        newY0_iter = Y0_iter - LengthStep*dJ;
        %newY0_iter(newY0_iter<0) = 0; 
        
        [newPnorm,newY_iter] = U2norm(Y0_iter);
        
        while newPnorm >= Pnorm 
            LengthStep = 0.25*LengthStep;
            % Update Y0
            newY0_iter = Y0_iter - LengthStep*dJ;
            %newY0_iter(newY0_iter<0) = 0; 
            % Obtain the cost function value
            [newPnorm,newY_iter] = U2norm(newY0_iter);
            %
            if LengthStep < 1e-20
                break
            end
        end
        
        Pnorm       = newPnorm;
        LengthStep  = 4*LengthStep;
        Y0_iter     = newY0_iter;
        Y_iter      = newY_iter;

        
        dJ = U2gradient(Y_iter);

        %

        % Graphs Options
        if mod(iter,20) == 0        
            waitbar(iter/MaxiIter,hd)

            Y0_iter_ms = reshape(Y0_iter,Nx,Ny);
            h.surf_estimation.ZData =  Y0_iter_ms;
            pause(0.01)
        end
        
        if Pnorm < 0.5
            break
        end 
    end
    
    delete(hd)
    h.EstimationInitialCondition = Y0_iter;
    h.EstimationSolution = Y_iter;

    %delete(h.SourcePlot)
    %h.SourcePlot = plotsources(h.axes.EstimationGraphs,Sources);
    
    
    %%
    function varargout = U2norm(iY0)
        
        idyn.InitialCondition = iY0;
        [~ , iY0iter ] = solve(idyn);

        varargout{1} = norm(iY0iter(end,:)' - YT);
        varargout{2} = iY0iter;

    end

    function varargout = U2gradient(iY0iter)
            adjoint.InitialCondition = iY0iter(end,:)' - YT;
            [~,P]   = solve(adjoint);
            varargout{1}    = 1e-6*(iY0iter(1,:)').^2 + P(end,:)';

    end
    
end


