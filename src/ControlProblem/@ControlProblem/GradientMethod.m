function GradientMethod(iCP,varargin)
    % name: GradientMethod
    % autor: JOroya
    % MandatoryInputs:   
    %   iCP: 
    %       name: Control Problem
    %       description: 
    %       class: ControlProblem
    %       dimension: [1x1]
    % OptionalInputs;
    %   U0:
    %       name: Initial Control 
    %       description: matrix 
    %       class: double
    %       dimension: [length(iCP.tline)]
    %       default:
    
    %%
    % ======================================================
    % ======================================================
    %               PARAMETERS DEFINITION
    % ======================================================
    % ======================================================
   
    %% Control Problem Parameters
    pinp = inputParser;
    addRequired(pinp,'iControlProblem')
    %%
    Udefault = zeros(length(iCP.ode.tline),length(iCP.ode.symU));
    addOptional(pinp,'U0',Udefault)
    %% Method Parameter
    addOptional(pinp,'maxiter',50)
    addOptional(pinp,'tol',0.001)
    addOptional(pinp,'DescentParameters',{})
    addOptional(pinp,'graphs',false)
    addOptional(pinp,'TypeGraphs','ODE')

    addOptional(pinp,'restart',false)

    %% 
    addOptional(pinp,'StoppingCriteria',@FunctionalStopCriteria  )

    parse(pinp,iCP,varargin{:})

    U0                  = pinp.Results.U0;
    maxiter             = pinp.Results.maxiter;    
    tol                 = pinp.Results.tol;
    DescentParameters   = pinp.Results.DescentParameters;
    graphs              = pinp.Results.graphs;
    restart             = pinp.Results.restart;
    TypeGraphs          = pinp.Results.TypeGraphs;
    % ======================================================
    % ======================================================
    %                   INIT PROGRAM
    % ======================================================
    % ======================================================
    if restart
        if ~isempty(iCP.UOptimal)
            U0 = iCP.UOptimal;
        else
            warning('The parameter restart need a previus execution.')
        end
    end
    tic;
    
    if graphs 
        % initial axes 
        [axY,axU,axJ] = init_graphs(TypeGraphs);
    end
    
    %% Obtenemos las primera U Y J
    Yhistory = cell(1,maxiter);
    Uhistory = cell(1,maxiter);
    Jhistory = zeros(1,maxiter);
    
    Uold = U0;    
    
    solve(iCP.ode,'U',Uold);
    
    Yold = iCP.ode.Y;
    Jold = GetFunctional(iCP,Yold,Uold);
    % clean the peersisten variable LengthStepMemory
    clear ClassicalDescent
    
    for iter = 1:maxiter
        % Create a funtion u(t) 
        % Update Control
        [Unew, Ynew,Jnew] = ClassicalDescent(iCP,Uold,Yold,Jold,DescentParameters{:});

        % Save history of optimization
        Uhistory{iter} = Unew;
        Yhistory{iter} = Ynew;
        Jhistory(iter) = Jnew;
        
        % Stopping Criteria
        if iter~=1
            error = norm(Uold-Unew)/norm(Unew);
           if error < tol
              break 
           end
        end

        Uold = Unew;
        Yold = Ynew;
        Jold = Jnew;
        %%
        if graphs   
            % plot the graphical convergence 
            bucle_graphs(axY,axU,axJ,Ynew,Unew,Jhistory,iCP.ode.tline,iter,TypeGraphs)
        end
    end
    
    
    if iter == maxiter 
        warning('Max iteration number reached!!')
    end
    
    iCP.time            = toc; 
    iCP.iter            = iter;
    iCP.uhistory        = Uhistory(1:iter);
    iCP.yhistory        = Yhistory(1:iter);
    iCP.Jhistory        = Jhistory(1:iter);
    iCP.precision       = error;
end


%% 
function [axY,axU,axJ] = init_graphs(TypeGraphs)
   f = figure;
   axY = subplot(1,3,1,'Parent',f);
   axU = subplot(1,3,2,'Parent',f);

   switch TypeGraphs
       case 'ODE'
           axY.Title.String = 'Y_i(t)';
           axY.XLabel.String = 't';
           axU.Title.String = 'U(t)';
           axU.XLabel.String = 't';
       case 'PDE'
           axY.Title.String = 'Y(x,T)';
           axY.XLabel.String = 'x';
           axU.Title.String = 'U(x,T)';
           axU.XLabel.String = 'x';
   end

   axJ = subplot(1,3,3,'Parent',f);
   axJ.Title.String = 'J';
   axJ.XLabel.String = 'iter';
end

function bucle_graphs(axY,axU,axJ,Ynew,Unew,Jhistory,tline,iter,TypeGraphs)

    Color = {'r','g','b','y','k','c'};
    LineStyle = {'-','--','-.'};

    switch TypeGraphs
        case 'ODE'
            iter_graph = 0;
            for iy = Ynew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                index_lineS = 1+ mod(iter_graph-1,length(LineStyle));
                line(tline,iy,'Parent',axY,'Color',Color{index_color},'LineStyle',LineStyle{index_lineS},'Marker','.')
            end

            iter_graph = 0;
            for iu = Unew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                index_lineS = 1+ mod(iter_graph-1,length(LineStyle));
                line(tline,iu,'Parent',axU,'Color',Color{index_color},'LineStyle',LineStyle{index_lineS},'Marker','.')
            end                  
        case 'PDE'
            line(1:length(Ynew(end,:)),Ynew(end,:),'Parent',axY)
            line(1:length(Unew(end,:)),Unew(end,:),'Parent',axU,'Marker','.')                       
    end


    line(1:iter,Jhistory(1:iter),'Parent',axJ,'Color','b','Marker','s')

    pause(0.05)
end




