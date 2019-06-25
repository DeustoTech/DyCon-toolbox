function  [ControlNew ,Ynew,Pnew,Jnew,dJnew,error,stop] = ConjugateDescent(iCP,tol,varargin)
%  description: This method is used within the GradientMethod method. GradientMethod executes iteratively this rutine in order to get 
%               one update of the control in each iteration. In the case of choosing ConjugateGradientDescent this function updates the
%               control of the following way
%                 $$u_{old}=u_{new}-\alpha_k s_k$$
%                 where $s_k$ is the descent direction.
%                 The optimal control problem is defined by
%                 $$\min J=\min (\Psi (t,Y(T))+\int^T_0 L(t,Y,U)dt)$$
%                 subject to
%                 $$\frac{d}{dt}Y=f(t,Y,U).$$
%                 The gradient of $J$ is
%                 $$dJ=\partial_u H=\partial_uL+p\partial_uf$$
%                 An $p$ is computed using
%                 $$-\frac{d}{dt}p = f_Y (t,Y,U)p+L_Y(Y,U)$$
%                 $$ p(T)=\psi_Y(Y(T))$$
%                 Since one the expression of the gradient, we can start with an initial control, solve the adjoint problem and evaluate 
%                 the gradient. Then one updates the initial control in the direction of the approximate gradient with a step size
%                 $\alpha_k$. $\alpha_k$ is determined by trying to solve numerically the following
%                 $$\min_{\alpha_k}J(y_k,u_k-\alpha_k s_k)$$
%                 where $s_k$ is choosen using the gradient of $J$.
%                 Then, the follow $s_{k+1}$ is compute by
%                 $$ s_{k+1} = -dJ_{k+1} + \beta_{k} s_{k}$$
%                 where
%                 $$ \beta_{k} = || dJ_{k+1} || / || dJ_{k} ||$$
%                 This routine will tell to GradientMethod to stop when the minimum tolerance of the derivative
%                (or the relative error, user's choice) is reached. Moreover there is a maximum of iterations allowed.
%  little_description: This method is used within the GradientMethod method. GradientMethod executes iteratively this rutine in order to get 
%               one update of the control in each iteration.
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
    addOptional(p,'StopCriteria','relative')
    addOptional(p,'DirectionParameter','FR')
    parse(p,iCP,varargin{:})

    StopCriteria = p.Results.StopCriteria;
    DirectionParameter = p.Results.DirectionParameter;
    
    persistent Iter
    persistent s
    persistent SeedLengthStep


    if isempty(Iter)
        %% First Iteration
        ControlNew = iCP.Solution.ControlHistory{1};
        %
        [Jnew,dJnew,Ynew,Pnew] = Control2Functional(iCP,ControlNew);
        % 
        dJnew = dJnew/iCP.Dynamics.dt;
        Iter = 1;
        error = 0;
        stop = false;
        SeedLengthStep = 0.01;
        s = -dJnew;
    else
        %% Others Iterations
        Iter = Iter + 1;
        %
        ControlOld  = iCP.Solution.ControlHistory{Iter-1};
        dJold       = iCP.Solution.dJhistory{Iter-1};
        Jold        = iCP.Solution.Jhistory(Iter-1);
         
        options = optimoptions(@fminunc,'SpecifyObjectiveGradient',false,'Display','none','Algorithm','quasi-newton','CheckGradients',false);

        if Iter > 2
            options.FunctionTolerance = 0.1*abs(Jold -iCP.Solution.Jhistory(Iter-2));
        end
        %% Search Optimal Length Step
        Jnew = Jold + 1e5;
        while Jold < Jnew 
            [OptimalLenght,Jnew] = fminunc(@SearchLenght,SeedLengthStep,options);
            SeedLengthStep = 0.25*SeedLengthStep;
            if abs(OptimalLenght) < 1e-10
                warning('The Optimal length step of Conjugate Gradient is zero. Possible local minimum.')
                OptimalLenght = 0;
                Jnew = Jold;
            end
        end

        SeedLengthStep = 4*OptimalLenght;
        %% Update Control with Optimal Length Step
        ControlNew = ControlOld + OptimalLenght*s; 
        ControlNew = UpdateControlWithConstraints(iCP.Constraints,ControlNew);
        
        %% Calculate new functional, adjoint, state, gradient
        [Jnew,dJnew,Ynew,Pnew] = Control2Functional(iCP,ControlNew);
        dJnew = dJnew/iCP.Dynamics.dt;
        %% Update Beta 
        diffdJ = dJnew - dJold;
        switch DirectionParameter
          case 'FR' % Fletcher-Reeves method
            beta  = dot(iCP,dJnew,dJnew)/dot(iCP,dJold,dJold);
          case 'PPR' %Positive Polak-Ribi\'ere.
            beta0 = dot(iCP,dJnew,diffdJ)/dot(iCP,dJold,dJold);
            beta  = max(0,beta0);
          case 'PR' % Polak-Ribi\'ere method
            beta  = dot(iCP,dJnew,diffdJ)/dot(iCP,dJold,dJold);
          case 'HS' % Hestenes-Stiefel method
            beta  = dot(iCP,dJnew,diffdJ)/dot(iCP,s,diffdJ);
          case 'DY' % Dai-Yuan method
            beta  = dot(iCP,dJnew,dJnew)/dot(iCP,s,diffdJ);
          otherwise %'Popular choice': Positive Polak-Ribi\'ere.
            beta0  = dot(iCP,dJnew,diffdJ)/dot(iCP,dJold,dJold);
            beta  = max(0,beta0);
        end
        beta = sqrt(beta);
        %%% Update Direction
        s = - dJnew + beta*s;
        %%
        % Possible stopping criterion for constrainted control problems.
        % Call it using GradientMethod(...,'DescentParameters',{'StopCriteria','Jdiff'}).
        switch StopCriteria
          case 'relative'
            AdJnew = norm(dJnew);
            AUnew =  norm(ControlNew);
            error = AdJnew/AUnew;
          case {'JDiff','Jdiff','jdiff'}
            % Stop when the difference of J is smaller than tol^2 + Jold*tol.
            error = (Jold-Jnew)/(Jold+tol);
          case 'absolute'
            error =  norm(dJnew);
          otherwise
            AdJnew =  norm(dJnew);
            AUnew  =  norm(ControlNew);
            error  = AdJnew/AUnew;
        end
        
        if error < tol || OptimalLenght == 0 || abs(Jnew-Jold) < 1e-6
            stop = true;
        else 
            stop = false;
        end
    end
   

    function Jsl = SearchLenght(LengthStep)
        
        Usl = ControlOld + LengthStep*s; 
        Usl = UpdateControlWithConstraints(iCP.Constraints,Usl);

        Jsl = Control2Functional(iCP,Usl);
        
    end
end

