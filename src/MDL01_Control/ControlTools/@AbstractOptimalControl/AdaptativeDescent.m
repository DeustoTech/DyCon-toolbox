function  [ControlNew ,Ynew,Pnew,Jnew,dJnew,error,stop] = AdaptativeDescent(iCP,tol,varargin)
%  description: This method is used within the GradientMethod method. GradientMethod executes iteratively this rutine
%               in order to get one update of the control in each iteration. In the case of choosing AdaptativeDescent 
%               this function updates the control of the following way
%                 $$u_{old}=u_{new}-\alpha_k dJ$$
%                 where dJ is an approximation of the gradient of J that has been obtained considering the adjoint state of the optimality condition of Pontryagin principle. The optimal control problem is defined by
%                 $$\min J=\min\Psi (t,Y(T))+\int^T_0 L(t,Y,U)dt$$
%                 subject to
%                 $$\frac{d}{dt}Y=f(t,Y,U).$$
%                 The gradient of $$J$$ is
%                 $$dJ=\partial_u H=\partial_uL+p\partial_uf$$
%                 An approximation $$p$$ is computed using
%                 $$-\frac{d}{dt}p = f_Y (t,Y,U)p+L_Y(Y,U)$$
%                 $$ p(T)=\psi_Y(Y(T))$$
%                 Since one the expression of the gradient, we can start with an initial control, solve the adjoint problem and evaluate the gradient. Then one updates the initial control in the direction of the approximate gradient with a step size $$\alpha_k$$. $$\alpha_k$$ is determined by a small variation of the Armijo stepsize rule. In each iteration the algorithm multiplies the stepsize by to $$\alpha_k=2\alpha_{k-1}$$ and checks if $$J(y_k,u_k)<J(y_{k-1},u_{k-1})$$ in case to be true continues to the next iteration, in case to be false it devides by two the stepsize until the condition is fulfilled or the minimum stepsize is reached.
%                 In this routine the user has to choose the minimum step size.
%                 This routine will tell to GradientMethod to stop when the minimum tolerance of the derivative (or the relative error, user's choice) is reached. Moreover there is a maximum of iterations allowed.
%  little_description: This method is used within the GradientMethod method. GradientMethod executes iteratively this rutine
%               in order to get one update of the control in each iteration.
%  autor: JOroya
%  MandatoryInputs:   
%    iCP: 
%        description: Control problem object, it carries all the information about the dynamics, the functional to be minimized and moreover the updates of the current best control find so far.
%        class: ControlProblem
%        dimension: [1x1]
%    tol: 
%        description: the tolerance desired.  
%        class: double
%        dimension: [1x1]
%  OptionalInputs:
%    InitialLengthStep: 
%        description: This parameter is the length step of the gradient method that is going to be used at the begining of the process. By default, this is 0.1.
%        class: double
%        dimension: [1x1]
%    MinLengthStep: 
%        description: This paramter is the lower bound on the length step of the gradient method if the algorithm needs to have a step size lower than this size it will make the GradientMethod stop.
%        class: double
%        dimension: [1x1]
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
%    dJnew:
%        description: New Value of gradient 
%        class: double
%        dimension: [1x1]
%    error:
%        description: the error $\vert dJ \vert / \vert U \vert $  
%        class: double
%        dimension: [1x1]
%    stop:
%        description: New Value of functional 
%        class: logical
%        dimension: [1x1]
    p = inputParser;
    addRequired(p,'iCP')
    addRequired(p,'tol')
    addOptional(p,'StopCriteria','relative')
    addOptional(p,'TypeNorm','L1')
    addOptional(p,'InitialLengthStep',0.1)
    addOptional(p,'MinLengthStep',1e-15)
    
    parse(p,iCP,tol,varargin{:})
    
    StopCriteria = p.Results.StopCriteria;
    TypeNorm = p.Results.TypeNorm;

    persistent Iter
    
    if isempty(Iter)
        ControlNew = iCP.Solution.ControlHistory{1};
        %
        [Jnew,dJnew,Ynew,Pnew] = Control2Functional(iCP,ControlNew);
        % 
        Iter = 1;
        error = 0;
        stop = false;

    else
        Iter = Iter + 1;
        
        ControlOld  = iCP.Solution.ControlHistory{Iter-1};
        Yold        = iCP.Solution.Yhistory{Iter-1};
        Pold        = iCP.Solution.Phistory{Iter-1};
        dJold       = iCP.Solution.dJhistory{Iter-1};
        Jold        = iCP.Solution.Jhistory(Iter-1);
        
        [ControlNew,Ynew,Pnew,Jnew,dJnew] = MiddleControlFcn(iCP,ControlOld,Yold,Pold,Jold,dJold,varargin{:});
        
        %% Stop Criteria 
        
        switch TypeNorm
            case 'L1'
                AdJnew = norm(dJnew,1);
            case 'L2'
                AdJnew = norm(dJnew,2);
        end
        %%%
        switch StopCriteria
            case 'absolute'
                error = AdJnew;
            case 'relative'
                AUnew = norm(ControlNew);
                error = AdJnew/AUnew;
            case {'Jdiff','jdiff','JDiff'}
                error = (Jold-Jnew)/(Jold+tol);    % Stop when the difference of J is smaller than tol^2 + Jold*tol.
        end
        %%%
        if error < tol || norm(ControlNew - ControlOld) == 0
            stop = true;
        else 
            stop = false;
        end
        
    end
   
end
%%
function [Unew,Ynew,Pnew,Jnew,dJnew] = MiddleControlFcn(iCP,Uold,Yold,Pold,Jold,dJold,varargin)

    p = inputParser;
    addRequired(p,'iCP')
    addRequired(p,'Uold')
    addRequired(p,'Yold')
    addRequired(p,'Jold')
    addRequired(p,'dJold')

    addOptional(p,'StopCriteria','relative')
    addOptional(p,'InitialLengthStep',0.5)
    addOptional(p,'MinLengthStep',1e-10)
    addOptional(p,'TypeNorm','L1')

    
    parse(p,iCP,Uold,Yold,Jold,dJold,varargin{:})
    
    InitialLengthStep   = p.Results.InitialLengthStep;
    MinLengthStep       = p.Results.MinLengthStep;
    TypeNorm            = p.Results.TypeNorm;
    %%
    persistent LengthMemory
     
    if isempty(LengthMemory) 
        LengthMemory = InitialLengthStep;
    else
        InitialLengthStep = LengthMemory;
    end
    
    %% Empezamos con un LengthStep
    LengthStep =2*InitialLengthStep;
    
    while true 
        % en cada iteracion dividimos el LengthStep
        LengthStep = LengthStep/2;
        %% Actualizamos  Control
        switch TypeNorm
            case 'L1'
                normdJold =norm(dJold,1);
            case 'L2'
                normdJold =norm(dJold,2);
        end
        ControlTry = Uold - LengthStep*dJold/normdJold;
        ControlTry = UpdateControlWithConstraints(iCP.Constraints,ControlTry);
        %% Resolvemos el problem primal
        [JTry,dJTry,YTry,PTry] = Control2Functional(iCP,ControlTry);
     
        if ((JTry - Jold) <= 0)
            %%
            Pnew  = PTry;
            Unew = ControlTry;
            Ynew = YTry;
            Jnew = JTry;
            dJnew = dJTry;
            %
            LengthMemory = 2*LengthStep;
            return
        end
        if (LengthStep <= MinLengthStep)
            %%
            Pnew = Pold;
            Unew = Uold;
            Ynew = Yold;
            Jnew = Jold;
            dJnew = dJold;

            warning(" Length Step ="+LengthStep+newline+" The Min Length Step of the Adaptative Descent has been achieve")
            return
        end
    end
end
