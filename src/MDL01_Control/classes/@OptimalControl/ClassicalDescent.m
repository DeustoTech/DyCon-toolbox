function  [Unew ,Ynew,Jnew,dJnew,error,stop] = ClassicalDescent(iCP,tol,varargin)
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
    addOptional(p,'LengthStep',0.1)
   
    parse(p,iCP,varargin{:})

    LengthStep = p.Results.LengthStep;
    stop = false;
    
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
        
        dJnew = GetNumericalGradient(iCP,Uold,Yold);
        
        
        %% Actualizamos  Control
        Unew = Uold - LengthStep*dJnew; 
        %% Resolvemos el problem primal
        solve(iCP.ode,'Control',Unew);
        Ynew = iCP.ode.VectorState.Numeric;
        Jnew = GetFunctional(iCP,Ynew,Unew);
        
        tspan = iCP.ode.tspan;
        AdJnew = mean(abs(trapz(tspan,dJnew)));
        AUnew = mean(abs(trapz(tspan,Unew)));
        error = AdJnew/AUnew;
        if error < tol
            stop = true;
        else 
            stop = false;
        end
    end
   
end
