function btn_gm_callback(obj,event,h)
%BTN_GM_CALLBACK Summary of this function goes here
%   Detailed explanation goes here

Nx    = h.grid.Nx;
Ny    = h.grid.Ny;
xline = h.grid.xline;
yline = h.grid.yline;
gamma = 0;

YT     = h.FinalCondition;
if isempty(YT)
   errordlg('Need a Final Condition. Click in Random Distribution or Click in Left Axis') 
    return
end

idyn = h.dynamics;
A = h.matrix.A;
V = h.matrix.V;
%%

adjoint = copy(idyn);
adjoint.dt = 2*adjoint.dt;
adjoint.A = A - V;

%Y0_iter = 1.0*YT;
Y0_iter = 0.0*YT;

Y0_iter_ms = reshape(Y0_iter,Nx,Ny);

    %
h.surf_estimation.ZData = Y0_iter_ms;

    LengthStep = 1;
    
    [Pnorm , Y_iter ] = U2norm(Y0_iter);
    dJ = U2gradient(Y_iter);
    
    hd = waitbar(0,'Loading ...');
    
    MaxiIter = 500;
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

        % Graphs Options
        if mod(iter,20) == 0        
            waitbar(iter/MaxiIter,hd)

            Y0_iter_ms = reshape(Y0_iter,Nx,Ny);
            h.surf_estimation.ZData =  Y0_iter_ms;
            pause(0.01)
        end
        
        if Pnorm < 0.1
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
        [~ , iYiter ] = solve(idyn);

        F = (YT - iYiter(end,:)').^2;
        %Fms             = reshape(      F           ,Nx,Ny);

        %Regularization  = reshape( abs(iYiter(1,:)) ,Nx,Ny);

        %J =   0.5* trapz(xline,trapz(yline,Fms,2))      ...
        %    + gamma*trapz(xline,trapz(yline,Regularization,2)) ; 
        
        J = norm(F);
        %figure(3)   
        %surf(Fms)
        %zlim([0 1.5])
        varargout{1} = J;
        varargout{2} = iYiter;

    end

    function varargout = U2gradient(iYiter)
            adjoint.InitialCondition = iYiter(end,:)' - YT;
            [~,P]   = solve(adjoint);
            varargout{1}    = +gamma*sign(iYiter(1,:)') + P(end,:)';

    end

end


