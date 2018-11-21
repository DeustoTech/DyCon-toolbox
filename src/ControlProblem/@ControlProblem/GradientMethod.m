function GradientMethod(iControlProblem,T,varargin)
    % ======================================================
    % ======================================================
    %               PARAMETERS DEFINITION
    % ======================================================
    % ======================================================
   
    %% Control Problem Parameters
    pinp = inputParser;
    addRequired(pinp,'iControlProblem')
    addRequired(pinp,'T')
    %
    dt = iControlProblem.ode.dt;
    iControlProblem.ode.tline = 0:dt:T;
    tline = iControlProblem.ode.tline;
    %
    udefault = ones(length(iControlProblem.ode.tline),length(iControlProblem.ode.symU));
    addOptional(pinp,'u0',udefault)
    %% Method Parameter
    addOptional(pinp,'maxiter',100)
    addOptional(pinp,'tol',0.001)
    
    addOptional(pinp,'StoppingCriteria',@FunctionalStopCriteria  )

    parse(pinp,iControlProblem,T,varargin{:})

    u0                  = pinp.Results.u0;
    maxiter             = pinp.Results.maxiter;    
    
    % ======================================================
    % ======================================================
    %                   INIT PROGRAM
    % ======================================================
    % ======================================================
    tic;
        

    L   = iControlProblem.Jfun.numL;
    Psi = iControlProblem.Jfun.numPsi;

    F   = iControlProblem.ode.numF;
    
    syms t
    
    %% Obtenemos dP/dt () 
    [dP_dt_xuDepen, P0_xt_Depen,dH_du] = GetAdjointProblem(iControlProblem);
    
    % Creamos una estructura que se mantendra fija en cada iteracion
    % 
    Descent_Struct.iControlProblem  = iControlProblem;
    Descent_Struct.dX_dt_uDepen     = F;
    Descent_Struct.dP_dt_xuDepen    = dP_dt_xuDepen;
    Descent_Struct.P0_xt_Depen      = P0_xt_Depen;
    Descent_Struct.dH_du            = dH_du;
    Descent_Struct.T                = T;
    
    
    u = u0;
    xhistory = cell(1,maxiter);
    uhistory = cell(1,maxiter);
    Jhistory = zeros(1,maxiter);
    
    %%%%% Solo son Graficos 
    f = figure;
    ax1 = subplot(3,1,1);
    ax1.XLabel.String = 't'; ax1.YLabel.String = 'x_i(t)';

    ax2 = subplot(3,1,2);
    ax2.XLabel.String = 't';ax2.YLabel.String = 'u_i(t)';
    
    
    ax3 = subplot(3,1,3);
    ax3.XLabel.String = 'iter';ax3.YLabel.String = 'J functional';
    %%%%%%%
    
    
    for iter = 1:maxiter
        %
        uOldfun = @(t) interp1(tline,u,t);
        %
        [u, xOld] = ClassicalDescent(Descent_Struct,u);
        %
        xOldfun = @(t) interp1(tline,xOld,t);
        
        %
        Lvalues = arrayfun(@(t)  L(t,xOldfun(t)',uOldfun(t)),tline);
        Larea   = trapz(tline,Lvalues);
        %        % 
        Jvalue = Larea + Psi(T,xOldfun(T));
        
        % Save history of optimization
        uhistory{iter} = u;
        xhistory{iter} = xOld;
        Jhistory(iter) = Jvalue;
        
        %%%% Solo graficos 
        delete(ax1.Children)
        line(tline,xOld(:,1),'LineStyle','-','Color','red','Parent',ax1);
        line(tline,xOld(:,2),'LineStyle','--','Color','blue','Parent',ax1)
        line(tline,u,'LineStyle','--','Color','blue','Parent',ax2)
        line(1:iter,Jhistory(1:iter),'Parent',ax3,'Marker','o')
        %%%
        pause(0.1)
        
        
        if iter~=1
           if  abs(Jvalue-Jhistory(iter-1))/Jhistory(iter-1) < 0.001
              break 
           end
        end
    end
    
    iter = iter - 1;
    
    iControlProblem.time            = toc; 
    iControlProblem.uOptimal        = u;
    iControlProblem.iter            = iter;
    iControlProblem.uhistory        = uhistory(1:iter);
    iControlProblem.xhistory        = xhistory(1:iter);
    iControlProblem.Jhistory        = Jhistory(1:iter);
end







