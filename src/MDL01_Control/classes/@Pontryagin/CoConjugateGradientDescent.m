function  [fnew,dfnew,Unew ,Ynew,Jnew,error,stop] = CoConjugateGradientDescent(iCP,tol,varargin)
%  description: This method is used within the GradientMethod method. GradientMethod executes 
%               iteratively the algorithms that we give it. In the case of choosing ClassicalDescent 
%               this function updates the control of the following way 
%                   $$ u_{old} = u_{new} + \\alpha dJ $$
%               where dJ has obtain with the optimality condition of
%               pontryagin principle. The optimal control problem is define
%               by
%               $$ \\min J = \\min \\Psi(t,Y(T)) + \\int_0^T L(t,Y,U) dt $$
%               subject to
%               $$ Y = f(t,Y,U) $$ 
%               following the Pontryagin principle 
%               $$ dJ = \\partial_u H = \\partial_u L + p \\partial_u f $$
%               Since we have the expression of the gradient, we can start with an initial control,
%               solve the adjoint problem and evaluate the gradient. Then we will update the initial 
%               control with the gradient.
%  little_description: This method is able to update the value of the control by decreasing the value of the functional. 
%  autor: JOroya
%  MandatoryInputs:   
%    iCP: 
%        description: Control Problem Object
%        class: ControlProblem
%        dimension: [1x1]
%    tol: 
%        description: Control Vector in time  
%        class: double
%        dimension: [M,iCP.tspan]
%  OptionalInputs:
%    LengthStep: 
%        description: This paramter is the length step of the gradient
%                       method. By default, this is 0.1
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
%        description: the error $\\vert dJ \\vert / \\vert U \\vert $  
%        class: double
%        dimension: [1x1]
%    stop:
%        description: New Value of functional 
%        class: logical
%        dimension: [1x1]
    p = inputParser;
    
    addRequired(p,'iCP')
    addRequired(p,'tol')

    addOptional(p,'LengthStep',0.1)
   
    parse(p,iCP,tol,varargin{:})

    LengthStep = p.Results.LengthStep;
    stop = false;
    
    persistent Iter
    persistent w
    persistent FirstError

    if isempty(Iter)
        
        %%
        
        fnew = iCP.Solution.fhistory{1};
        %%
        
        iCP.Adjoint.Dynamics.InitialCondition = fnew;
        [~ ,P] =solve(iCP.Adjoint.Dynamics);
        P = flipud(P);
    
        %% 

        Unew = GetNumericalAdjoint2Control(iCP,P);
        [~ ,Ynew] = solve(iCP.Dynamics,'Control',Unew);
        PT = GetNumericalAdjointFinalCondition(iCP,Ynew);
         
        %% Calculate Gradient
        dfnew = -fnew + PT';

        %%
        Jnew = GetNumericalFunctional(iCP,Ynew,Unew);
        Iter = 1;
        error = 0;
        w = dfnew;
        stop = false;
        %%
        FirstError = sqrt(dfnew.'*dfnew);
        
    else
        
        Iter = Iter + 1;
        fold= iCP.Solution.fhistory{Iter-1};
        fnew = fold - w;
        %%
        iCP.Adjoint.Dynamics.InitialCondition = fnew;
        [~ ,P] =solve(iCP.Adjoint.Dynamics);
        P = flipud(P);
        %% 

        Unew = GetNumericalAdjoint2Control(iCP,P);
        [~ ,Ynew] = solve(iCP.Dynamics,'Control',Unew);
        PT = GetNumericalAdjointFinalCondition(iCP,Ynew);
        
        %% Calculate Gradient
        dfnew = -fnew + PT';

        dfold  = iCP.Solution.dfhistory{Iter-1};
        fold   = iCP.Solution.fhistory{Iter-1};
        
        rho = (dfold'*dfold)/(dfnew'*w);
        %fnew  = fold  - rho*w;
        %dfnew = dfold - rho*dfnew;
        gamma = (dfnew'*dfnew)/(dfold'*dfold);
        w = dfnew + gamma*w;
        
        
        %%
        
        error = sqrt(dfnew'*dfnew)/FirstError;
        if error < tol
            stop = true;
        else 
            stop = false;
        end
        
        Jnew = GetNumericalFunctional(iCP,Ynew,Unew);
    end
end
