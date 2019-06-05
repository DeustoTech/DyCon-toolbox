function btn_gm_callback(obj,event,h)
%BTN_GM_CALLBACK Summary of this function goes here
%   Detailed explanation goes here

Nx    = h.grid.Nx;
Ny    = h.grid.Ny;
xline = h.grid.xline;
yline = h.grid.yline;
gamma = 1e-4;

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

    
    [Pnorm , Y_iter ] = U2norm(Y0_iter);
    dJ = U2gradient(Y_iter);
    s = -dJ;
    hd = waitbar(0,'Loading ...');
    
    MaxiIter = 50;
    seed = 1e-1;        
    
    options = optimoptions(@fminunc,'display','off');
    options.MaxIterations = 5;

    for iter = 1:MaxiIter
        [OptimalLengthStep,newPnorm ] = fminunc(@LengthStep2norm,seed,options);
        %[OptimalLengthStep,newPnorm ]= fmincon(@LengthStep2norm,seed,options);
        
        iter_try = 1;
        while newPnorm > Pnorm && iter_try < 3
            iter_try = iter_try + 1;
            seed = 0.1*seed;
            %[OptimalLengthStep,newPnorm ]= fminunc(@LengthStep2norm,seed,options);
            %minLength =-1e-6;
            [OptimalLengthStep,newPnorm ] = fminunc(@LengthStep2norm,seed,options);

            if abs(Pnorm-newPnorm) < 1e-5
               break 
            end
        end
        seed = 10*seed;
        
        Y0_iter = Y0_iter + OptimalLengthStep*s;
        %Y0_iter(Y0_iter<0) = 0; 
        
        [Pnorm,Y_iter] = U2norm(Y0_iter);
        
        dJnew = U2gradient(Y_iter);
        %Pnorm

        numems  = reshape( dJnew.*dJnew ,Nx,Ny);
        nume    = trapz(xline,trapz(yline,numems,2));
        
        denoms  = reshape( dJ.*dJ ,Nx,Ny);
        deno    = trapz(xline,trapz(yline,denoms,2));
        
        beta = nume/deno;
        
        s = -dJnew + beta*s;
        
        dJ = dJnew;
        
        
        % Graphs Options
        if mod(iter,3) == 0        
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
        Fms             = reshape(      F           ,Nx,Ny);

        Regularization  = reshape( abs(iYiter(1,:)) ,Nx,Ny);

        J =   0.5* trapz(xline,trapz(yline,Fms,2))      ...
            + gamma*trapz(xline,trapz(yline,Regularization,2)) ; 
        
        %J = norm(F);
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
    
    function iPnorm = LengthStep2norm(iLengthStep)
            inewY0_iter = Y0_iter + iLengthStep*s;
            %inewY0_iter(inewY0_iter<0) = 0;
            iPnorm = U2norm(inewY0_iter);
    end
end


