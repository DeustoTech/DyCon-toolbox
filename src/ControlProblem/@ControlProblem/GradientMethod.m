function GradientMethod(iControlProblem,varargin)
    % ======================================================
    % ======================================================
    %               PARAMETERS DEFINITION
    % ======================================================
    % ======================================================
   
    %% Control Problem Parameters
    pinp = inputParser;
    addRequired(pinp,'iControlProblem')
    %%
    Udefault = zeros(length(iControlProblem.ode.tline),length(iControlProblem.ode.symU));
    addOptional(pinp,'U0',Udefault)
    %% Method Parameter
    addOptional(pinp,'maxiter',50)
    addOptional(pinp,'tol',0.001)
    addOptional(pinp,'DescentParameters',{})
    addOptional(pinp,'graphs',false)
    addOptional(pinp,'restart',false)

    %% 
    addOptional(pinp,'StoppingCriteria',@FunctionalStopCriteria  )

    parse(pinp,iControlProblem,varargin{:})

    U0                  = pinp.Results.U0;
    maxiter             = pinp.Results.maxiter;    
    tol                 = pinp.Results.tol;
    DescentParameters   = pinp.Results.DescentParameters;
    graphs              = pinp.Results.graphs;
    restart              = pinp.Results.restart;
    % ======================================================
    % ======================================================
    %                   INIT PROGRAM
    % ======================================================
    % ======================================================
    if restart
        if ~isempty(iControlProblem.UOptimal)
            U0 = iControlProblem.UOptimal;
        else
            warning('The parameter restart need a previus execution.')
        end
    end
    tic;
    
    tline = iControlProblem.ode.tline;
    
    
    U = U0;
    yhistory = cell(1,maxiter);
    uhistory = cell(1,maxiter);
    Jhistory = zeros(1,maxiter);
    
    if graphs 
       f = figure;
       axY = subplot(1,3,1,'Parent',f);
       axY.Title.String = 'Y(x,T)';
       axY.XLabel.String = 'x';

       axU = subplot(1,3,2,'Parent',f);
       axU.Title.String = 'U(t)';
       axU.XLabel.String = 't';
       
       axJ = subplot(1,3,3,'Parent',f);
       axJ.Title.String = 'J';
       axJ.XLabel.String = 'iter';
    end
    
    %% Obtenemos las primera U Y J
    
    
    Uold = U;           
    solve(iControlProblem.ode,'U',Uold)
    
    Yold = iControlProblem.ode.Y;
    Jold = GetFunctional(iControlProblem,Yold,Uold);

    clear ClassicalDescent
    for iter = 1:maxiter
        % Create a funtion u(t) 
        % Update Control

        [Unew, Ynew,Jnew] = ClassicalDescent(iControlProblem,Uold,Yold,Jold,DescentParameters{:});

        
        % Save history of optimization
        uhistory{iter} = Unew;
        yhistory{iter} = Ynew;
        Jhistory(iter) = Jnew;
        


        % Criterio de Parada
        
        if iter~=1
            error = norm(Unew - Uold)/norm(Unew);
           if  sum(sum(error)) < tol
              break 
           end
        end

        Uold = Unew;
        Yold = Ynew;
        Jold = Jnew;
        %%
        %%
        if graphs
            line(1:length(Ynew(end,:)),Ynew(end,:),'Parent',axY)
            
            Color = {'r','g','b','y','k','c'};
            LineStyle = {'-','--','-.'};
            iter_graph = 0;
            for iu = Unew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                index_lineS = 1+ mod(iter_graph-1,length(LineStyle));
                line(tline,iu,'Parent',axU,'Color',Color{index_color},'LineStyle',LineStyle{index_lineS})
            end
            
            line(1:iter,Jhistory(1:iter),'Parent',axJ,'Color','b','Marker','s')
            
            pause(0.05)
            
        end
    end
    
    
    if iter == maxiter 
        warning('Max iteration number reached!!')
    end
    
    iControlProblem.time            = toc; 
    iControlProblem.iter            = iter;
    iControlProblem.uhistory        = uhistory(1:iter);
    iControlProblem.yhistory        = yhistory(1:iter);
    iControlProblem.Jhistory        = Jhistory(1:iter);
    
end







