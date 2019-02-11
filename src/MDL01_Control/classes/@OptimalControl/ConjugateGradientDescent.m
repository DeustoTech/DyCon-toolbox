function  [Unew ,Ynew,Jnew,dJnew,error,stop] = ConjugateGradientDescent(iCP,tol,varargin)
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
    
    persistent Iter
    persistent s
    
    if isempty(Iter)
        %% First 
        Unew = iCP.solution.Uhistory{1};
        %
        solve(iCP.ode,'Control',Unew);
        %
        Ynew = iCP.ode.VectorState.Numeric;
        Jnew = GetFunctional(iCP,Ynew,Unew);
        Iter = 1;
        error = 0;
        dJnew = GetNumericalGradient(iCP,Unew,Ynew);
        
        s = -dJnew;
        stop = false;
    else
        %%
        Iter = Iter + 1;
        
        Uold  = iCP.solution.Uhistory{Iter-1};
        
        [OptimalLenght,Jnew] = fminsearch(@SearchLenght,0);
        %
        Unew = Uold + OptimalLenght*s; 
        solve(iCP.ode,'Control',Unew);
        Ynew = iCP.ode.VectorState.Numeric;
        % 
        dJnew = GetNumericalGradient(iCP,Unew,Ynew);
        % 
        dJold = iCP.solution.dJhistory{Iter-1};
        tspan = iCP.ode.tspan;
        
        beta  = (trapz(tspan,sum(dJnew.^2,2)))/(trapz(tspan,sum(dJold.^2,2)));
       
        s = - dJnew + beta*s;

        AdJnew = mean(abs(trapz(tspan,dJnew)));
        AUnew = mean(abs(trapz(tspan,Unew)));
        error = AdJnew/AUnew;
        
        if error < tol || OptimalLenght == 0
            stop = true;
        else 
            stop = false;
        end
    end
   
    function Jsl = SearchLenght(LengthStep)
        
        Usl = Uold + LengthStep*s; 
        %% Resolvemos el problem primal
        solve(iCP.ode,'Control',Usl);
        Ysl = iCP.ode.VectorState.Numeric;
        Jsl = GetFunctional(iCP,Ysl,Usl);
    end
end

