function  [Unew ,Ynew,Pnew,Jnew,dJnew,error,stop] = ConjugateGradientDescent(iCP,tol,varargin)
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
   
    parse(p,iCP,varargin{:})

    T = iCP.ode.FinalTime;
    persistent Iter
    persistent s
    persistent SeedLengthStep
    if isempty(Iter)
        %% First Iteration
        Iter = 1;
        % Get First Control
        Unew = iCP.solution.Uhistory{1};
        % Solve Dynamics with this control
        [~, Ynew] = solve(iCP.ode,'Control',Unew);
        % Calculate de Functional numerical Value
        Jnew = GetFunctional(iCP,Ynew,Unew);
        % Calculate de Gradient numerical Value
        iCP.adjoint.ode.InitialCondition = iCP.adjoint.FinalCondition.Numeric(T,Ynew(end,:)');
        Pnew  = GetNumericalAdjoint(iCP,Unew,Ynew);
        dJnew = GetNumericalGradient(iCP,Unew,Ynew,Pnew);
        % Then set s variable equal minus gradient
        s = -dJnew;
        SeedLengthStep = 1; 
        %
        error = 0;       
        stop = false;
    else
        %% Others Iterations
        Iter = Iter + 1;
        %
        Uold  = iCP.solution.Uhistory{Iter-1};
        Yold  = iCP.solution.Yhistory{Iter-1};
        dJold = iCP.solution.dJhistory{Iter-1};
        
        %HessNew = GetNumericalHessian(iCP,Uold,Yold,Yold);
        %numerador   = arrayfun(@(indextime) dJold(indextime,:)*HessNew(:,:,indextime)*s(indextime,:)',1:length(iCP.ode.tspan));
        %denominador = arrayfun(@(indextime) s(indextime,:)*HessNew(:,:,indextime)*s(indextime,:)',1:length(iCP.ode.tspan));
        
        %OptimalLenght = +1* (numerador./denominador);
        options = optimoptions(@fminunc,'SpecifyObjectiveGradient',false,'Display','off');

        [OptimalLenght,Jnew] = fminunc(@SearchLenght,4*SeedLengthStep,options);
        SeedLengthStep = OptimalLenght;
        %
        Unew = Uold + (OptimalLenght.').*s; 
        [~ , Ynew] = solve(iCP.ode,'Control',Unew);
        %Jnew = GetFunctional(iCP,Ynew,Unew);

        % 
        iCP.adjoint.ode.InitialCondition = iCP.adjoint.FinalCondition.Numeric(T,Ynew(end,:)');
        

        Pnew  = GetNumericalAdjoint(iCP,Unew,Ynew);   
        dJnew = GetNumericalGradient(iCP,Unew,Ynew,Pnew);
        % 
        tspan = iCP.ode.tspan;
        
        beta  = (trapz(tspan,sum(dJnew.^2,2)))/(trapz(tspan,sum(dJold.^2,2)));
        %numerador   = arrayfun(@(indextime) dJnew(indextime,:)*HessNew(:,:,indextime)*s(indextime,:)',1:length(iCP.ode.tspan));
        %denominador = arrayfun(@(indextime) s(indextime,:)*HessNew(:,:,indextime)*s(indextime,:)',1:length(iCP.ode.tspan));
        %beta = numerador./denominador;
        
        s = - dJnew + (beta.').*s;

        AdJnew = mean(abs(trapz(tspan,dJnew)));
        AUnew = mean(abs(trapz(tspan,Unew)));
        error = AdJnew/AUnew;
        
        if error < tol || norm(OptimalLenght) == 0
            stop = true;
        else 
            stop = false;
        end
    end
   

    function Jsl = SearchLenght(LengthStep)
        
        Usl = Uold + LengthStep*s; 
        %% Resolvemos el problem primal
        [~ , Ysl] = solve(iCP.ode,'Control',Usl);
        Jsl = GetFunctional(iCP,Ysl,Usl);
        
%         iCP.adjoint.ode.InitialCondition = iCP.adjoint.FinalCondition.Numeric(T,Ysl(end,:)');
%         
%         Psl  = GetNumericalAdjoint(iCP,Usl,Ysl);
%         dJsl = GetNumericalGradient(iCP,Usl,Ysl,Psl);
%         
%         dJsl_s = arrayfun(@(indextime) s(indextime,:)*dJsl(indextime,:)',1:length(iCP.ode.tspan));
%         dJsl_s = trapz(iCP.ode.tspan,dJsl_s);
        
    end
end

