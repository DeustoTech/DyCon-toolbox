function GradientMethod(iCP,varargin)
    % name: GradientMethod
    % little_description: The gradient method is able to optimize the given functional, going down the gradient.
    % description: "The gradient method is able to optimize the given
    %                       functional, going down the gradient. El calculo del gradiente puede
    %                       ser de varios tipo. Por defecto la direccion y el modulo de descenso
    %                       se calcula con el gradiente conjugado
    %                       http://web.mit.edu/mitter/www/publications/2_conjugate_grad_IEEEAC.pdf"
    % autor: JOroya
    % MandatoryInputs:   
    %   iCP: 
    %       name: Control Problem
    %       description: 
    %       class: ControlProblem
    %       dimension: [1x1]
    % OptionalInputs:
    %   U0:
    %       name: Initial Control 
    %       description: matrix 
    %       class: double
    %       dimension: [length(iCP.tspan)]
    %       default: zeros
    %   MaxIter:
    %       name: Initial Control 
    %       description: matrix 
    %       class: double
    %       dimension: [1x1]
    %       default: 50
    %   tol:
    %       name: Initial Control 
    %       description: matrix 
    %       class: double
    %       dimension: 
    %       dimension: [1x1]
    %   DescentParameters:
    %       description: Parmater of Descent Method 
    %       class: double
    %       dimension: cell
    %       default: cell.empty    
    %   Graphs:
    %       description: Parameter that indicate if the method must plot the optimization, while is calculate 
    %       class: logical
    %       dimension: [1x1]
    %       default: false        
    %   TypeGraphs:
    %       description: Type of graphs. This parameter can be 'ODE' or 'PDE' 
    %       class: string
    %       dimension: [1x1]
    %       default: 'ODE'
    %   SaveGif:
    %       name: If this parameter is true, A gif of the optimization process is created
    %       description: matrix 
    %       class: double
    %       dimension: [length(iCP.tspan)]
    %       default: false
    %   restart:
    %       description: The optimization start with U0 = iCP.UOptimal
    %       class: double
    %       dimension: [1x1]
    %       default: false
    
    
    % ======================================================
    % ======================================================
    %               PARAMETERS DEFINITION
    % ======================================================
    % ======================================================
   
    %% Control Problem Parameters
    pinp = inputParser;
    addRequired(pinp,'iControlProblem')
    %%
    Udefault = zeros(length(iCP.ode.tspan),iCP.ode.Udim);
    addOptional(pinp,'U0',Udefault)
    %% Method Parameter
    addOptional(pinp,'MaxIter',500)
    addOptional(pinp,'tol',1e-3)
    addOptional(pinp,'DescentAlgorithm',@AdaptativeDescent)
    addOptional(pinp,'DescentParameters',{})
    %% Graphs Parameters
    addOptional(pinp,'Graphs',false)
    addOptional(pinp,'display',false)
    addOptional(pinp,'SaveGif',false)
    addOptional(pinp,'restart',false)

    %% 
    addOptional(pinp,'StoppingCriteria',@FunctionalStopCriteria  )

    parse(pinp,iCP,varargin{:})

    U0                  = pinp.Results.U0;
    MaxIter             = pinp.Results.MaxIter;    
    tol                 = pinp.Results.tol;
    Graphs              = pinp.Results.Graphs;
    restart             = pinp.Results.restart;
    SaveGif             = pinp.Results.SaveGif;
    DescentAlgorithm    = pinp.Results.DescentAlgorithm;
    DescentParameters   = pinp.Results.DescentParameters;
    display_parameter   = pinp.Results.display;
    % ======================================================
    % ======================================================
    %                   INIT PROGRAM
    % ======================================================
    % ======================================================
    if restart
        if ~isempty(iCP.solution.UOptimal)
            U0 = iCP.solution.UOptimal;
        else
            warning('The parameter restart need a previus execution.')
        end
    end
    tic;
    
    if Graphs 
        % initial axes 
        nY = length(iCP.ode.InitialCondition);
        nU = length(U0(1,:));
        TypeGraphs =  class(iCP.ode);
        [axY,axU,axJ] = init_graphs_gradientmethod(TypeGraphs,nY,nU,SaveGif);
    end
    
    %% Creamos un solucion vacia
    iCP.solution = CPSolution;

    iCP.solution.Yhistory = cell(1,MaxIter);
    iCP.solution.Uhistory = cell(1,MaxIter);
    iCP.solution.dJhistory = cell(1,MaxIter);

    iCP.solution.Jhistory = zeros(1,MaxIter);
    %
    iCP.solution.Uhistory{1} = U0;

        
    %% Clean the persiten variable LengthStepMemory
    clear(char(DescentAlgorithm))
    % ClassicalDescent
    % ConjugateGradientDescent
    % ConjugateGradienDescent
    
    for iter = 1:MaxIter
        % Create a funtion u(t) 
        % Update Control
        [Unew, Ynew,Pnew,Jnew,dJnew,error,stop] = DescentAlgorithm(iCP,tol,DescentParameters{:});

        % Save history of optimization
        iCP.solution.Uhistory{iter}  = Unew;
        iCP.solution.Yhistory{iter}  = Ynew;
        iCP.solution.Phistory{iter}  = Pnew;
        iCP.solution.Jhistory(iter)  = Jnew;
        iCP.solution.dJhistory{iter} = dJnew;
        iCP.solution.Ehistory(iter)     = error;
        
        switch display_parameter
            case 'all'
            display(     "error = "        + num2str(error,'%d')        + ...
                     " | Functional = "    + num2str(Jnew,'%d')         + ...
                     " | norm(Gradient) = "+ num2str(norm(dJnew),'%d')  + ...
                     " | norm(U) = "       + num2str(norm(Unew),'%d')   + ...
                     " | iter = "          + iter)
            case 'functional'
            display(     "error = "        + num2str(error,'%d')        + ...
                     " | Functional = "    + num2str(Jnew,'%d')         + ...
                     " | iter = "          + iter)
        end
        % Stopping Criteria
        if iter ~= 1 
            if Graphs   
                % plot the graphical convergence 
                bucle_graphs_gradientmethod(axY,axU,axJ,Ynew,Unew,iCP.solution.Jhistory,iCP.ode.tspan,iter,TypeGraphs,SaveGif,true)
            end
            if stop
                  break 
            end
        end 
    end
    
    
    if iter == MaxIter 
        warning('Max iteration number reached!!')
    end
    
    iCP.solution.precision = error;
    iCP.solution.Uhistory = iCP.solution.Uhistory(1:iter);
    iCP.solution.Jhistory = iCP.solution.Jhistory(1:iter);
    iCP.solution.dJhistory = iCP.solution.dJhistory(1:iter);
    iCP.solution.Yhistory = iCP.solution.Yhistory(1:iter);

    iCP.solution.iter = iter;
    iCP.solution.time = toc; 
    
    resume(iCP.solution)
end




