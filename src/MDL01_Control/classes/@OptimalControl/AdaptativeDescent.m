function  [Unew ,Ynew,Jnew,dJnew,error,stop] = AdaptativeDescent(iCP,tol,varargin)
%  description: This method is able to update the value of the control by decreasing 
%               the value of the functional. By calculating the gradient, $ \\frac{dH}{du}$. Also, it is decremented 
%               in that direction, assuring the decrease by the adaptive step size. 
%  little_description: This method is able to update the value of the control by decreasing the value of the functional. 
%  autor: JOroya
%  MandatoryInputs:   
%    iCP: 
%        description: Control Problem Object
%        class: ControlProblem
%        dimension: [1x1]
%    UOld: 
%        description: Control Vector in time  
%        class: double
%        dimension: [M,iCP.tspan]
%    YOld: 
%        description: State Vector in time 
%        class: double
%        dimension: [length(iCP.ode.Y0),iCP.tspan]
%    JOld: 
%        description: Value of functional J(Uold,Yold)
%        class: double
%        dimension: [length(iCP.ode.Y0),iCP.tspan]
%  OptionalInputs:
%    InitialLengthStep: 
%        description: This parameter is the step size if the MiddleStepControl option is false. 
%                       If the option MiddleStepControl is activated then this parameter is the initial step
%                       of the methodo but then the step is doubled in the case where the functional iteration 
%                       decreases and is divided by two its the functional one grows.
%        class: double
%        dimension: [1x1]
%    MinLengthStep: 
%        description: It may happen that although we divide the step of the descenco many times,
%                       we continue to obtain an update that increases the value of the functional. In this case,
%                       it is necessary to have a minimum step size to avoid infinite loops. This parameter is
%                       responsible for this.
%        class: double
%        dimension: [1x1]
%    MiddleStepControl: 
%        description: If this parameter is enabled, it allows the algorithm to search for different 
%                       step-logitudes, provided that the control update decrements the functional value. If it is
%                       deactivated, the descent of the gradient will be constant.
%        class: double
%        dimension: [length(iCP.ode.Y0),iCP.tspan]
%  Outputs:
%    Unew:
%        description: Update of Control Vector  
%        class: double
%        dimension: [Mxlength(iCP.tspan)]
%    Ynew:
%        description: Update of State Vector 
%        class: double
%        dimension: [length(iCP.tspan)]
%    Jnew:
%        description: New Value of functional 
%        class: double
%        dimension: [1x1]

    p = inputParser;
    addRequired(p,'iCP')
    addRequired(p,'tol')
    addOptional(p,'StopCriteria','relative')
    addOptional(p,'norm','L1')
    addOptional(p,'InitialLengthStep',0.1)
    addOptional(p,'MinLengthStep',1e-8)
    
    parse(p,iCP,tol,varargin{:})
    
    StopCriteria = p.Results.StopCriteria;
    norm = p.Results.norm;

    persistent Iter
    
    if isempty(Iter)
        Unew = iCP.solution.Uhistory{1};
        %
        solve(iCP.ode,'Control',Unew);
        %
        Ynew = iCP.ode.VectorState.Numeric;
        Jnew = GetFunctional(iCP,Ynew,Unew);
        Iter = 1;
        error = 0;
        dJnew = Unew;
        stop = false;

    else
        Iter = Iter + 1;
        
        Uold  = iCP.solution.Uhistory{Iter-1};
        Yold  = iCP.solution.Yhistory{Iter-1};
        Jold  = iCP.solution.Jhistory(Iter-1);
        
        [Unew,Ynew,Jnew,dJnew] = MiddleControlFcn(iCP,Uold,Yold,Jold,varargin{:});
        
        tspan = iCP.ode.tspan;
        
        switch norm
            case 'L1'
                AdJnew = mean(trapz(tspan,abs(dJnew)));
            case 'L2'
                AdJnew = mean(trapz(tspan,dJnew.^2));
        end
        %% 
        switch StopCriteria
            case 'absolute'
                error = AdJnew;
            case 'relative'
                AUnew = mean(trapz(tspan,abs(Unew)));
                error = AdJnew/AUnew;
        end
        %%
        if error < tol
            stop = true;
        else 
            stop = false;
        end
        
    end
   
end
%%
function [Unew,Ynew,Jnew,dJold] = MiddleControlFcn(iCP,Uold,Yold,Jold,varargin)

    p = inputParser;
    addRequired(p,'iCP')
    addRequired(p,'Uold')
    addRequired(p,'Yold')
    addRequired(p,'Jold')
    addOptional(p,'StopCriteria','relative')
    addOptional(p,'InitialLengthStep',0.5)
    addOptional(p,'MinLengthStep',1e-8)
    addOptional(p,'norm','L1')

    
    parse(p,iCP,Uold,Yold,Jold,varargin{:})
    
    InitialLengthStep   = p.Results.InitialLengthStep;
    MinLengthStep       = p.Results.MinLengthStep;
    norm                = p.Results.norm;
    %%
    persistent LengthMemory
     
    if isempty(LengthMemory) 
        LengthMemory = InitialLengthStep;
    else
        InitialLengthStep = LengthMemory;
    end
    
    %% Empezamos con un LengthStep
    LengthStep =2*InitialLengthStep;
    
    dJold = GetNumericalGradient(iCP,Uold,Yold);

    while true 
        % en cada iteracion dividimos el LengthStep
        LengthStep = LengthStep/2;
        %% Actualizamos  Control
        tspan = iCP.ode.tspan;
        switch norm
            case 'L1'
                normdJold = mean(trapz(tspan,abs(dJold)));
            case 'L2'
                normdJold = sqrt(mean(trapz(tspan,dJold.^2)));
        end
        UTry = Uold - LengthStep*dJold/normdJold; 
        %% Resolvemos el problem primal
        solve(iCP.ode,'Control',UTry);
        YTry = iCP.ode.VectorState.Numeric;
        % Calculate functional value
        JTry = GetFunctional(iCP,YTry,UTry);
     
        if ((JTry - Jold) <= 0)
            Unew = UTry;
            Ynew = YTry;
            Jnew = JTry;
            %
            LengthMemory = 2*LengthStep;
            return
        end
        if (LengthStep <= MinLengthStep)
            Unew = Uold;
            Ynew = Yold;
            Jnew = Jold;
            return
        end
    end
end
