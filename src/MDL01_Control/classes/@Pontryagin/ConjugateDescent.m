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
    addOptional(p,'StopCriteria','relative')
    addOptional(p,'DirectionParameter','FR')
    parse(p,iCP,varargin{:})

    StopCriteria = p.Results.StopCriteria;
    DirectionParameter = p.Results.DirectionParameter;
    
    persistent Iter
    persistent s
    persistent SeedLengthStep
    persistent HistoryOptimalLength

    tspan = iCP.dynamics.tspan;

    if isempty(Iter)
        %% First Iteration
        Iter = 1;
        % Get First Control
        Unew = iCP.solution.Uhistory{1};
        % Solve Dynamics with this control
        [~, Ynew] = solve(iCP.dynamics,'Control',Unew);
        % Calculate de Functional numerical Value
        Jnew = GetNumericalFunctional(iCP,Ynew,Unew);
        % Calculate de Gradient numerical Value
        Pnew  = GetNumericalAdjoint(iCP,Unew,Ynew);
        dJnew = GetNumericalControlGradient(iCP,Unew,Ynew,Pnew);
        % Then set s variable equal minus gradient
        s = -dJnew;
        SeedLengthStep = 0.01; 
        %
        error = 0;       
        stop = false;
        HistoryOptimalLength = [];
        %
    else
        %% Others Iterations
        Iter = Iter + 1;
        %
        Uold  = iCP.solution.Uhistory{Iter-1};
        dJold = iCP.solution.dJhistory{Iter-1};
        Jold = iCP.solution.Jhistory(Iter-1);
         
        options = optimoptions(@fminunc,'SpecifyObjectiveGradient',true,'Display','none','Algorithm','trust-region');
        %options = optimoptions(@fminunc,'SpecifyObjectiveGradient',false,'Display','off','Algorithm','quasi-newton');
        %options = optimoptions(@fminunc,'SpecifyObjectiveGradient',false,'Display','none','Algorithm','quasi-newton','CheckGradients',false);

        if Iter > 2
            options.FunctionTolerance = 0.1*abs(Jold -iCP.solution.Jhistory(Iter-2));
        end
        %% Search Optimal Length Step
        Jnew = Jold + 1;
        while Jold < Jnew 
            [OptimalLenght,Jnew] = fminunc(@SearchLenght,SeedLengthStep,options);
            SeedLengthStep = 0.5*SeedLengthStep;
            if abs(OptimalLenght) < 1e-10
                warning('The Optimal length step of Conjugate Gradient is zero. Possible local minimum.')
                OptimalLenght = 0;
                Jnew = Jold;
            end
        end

        SeedLengthStep = OptimalLenght;
        %% Update Control with Optimal Length Step
        Unew = Uold + OptimalLenght*s; 
        Unew = UpdateControlWithConstraints(iCP.constraints,Unew);
        
        [~ , Ynew] = solve(iCP.dynamics,'Control',Unew);
        % Get Gradient. DirectionParameter works here to find a proper
        % conjugate direction.
        Pnew  = GetNumericalAdjoint(iCP,Unew,Ynew);   
        dJnew = GetNumericalControlGradient(iCP,Unew,Ynew,Pnew);
        %diffdJ = dJnew - dJold;
        diffdJ = dJnew - dJold;
        switch DirectionParameter
          case 'FR' % Fletcher-Reeves method
            nume = arrayfun(@(indextime) dJnew(indextime,:)*dJnew(indextime,:).',1:length(tspan));
            nume = trapz(tspan,nume);
            deno = arrayfun(@(indextime) dJold(indextime,:)*dJold(indextime,:).',1:length(tspan));
            deno = trapz(tspan,deno);
            beta  = nume/deno;
          case 'PPR' %Positive Polak-Ribi\'ere.
            nume = arrayfun(@(indextime) dJnew(indextime,:)*diffdJ(indextime,:).',1:length(tspan));
            nume = trapz(tspan,nume);
            deno = arrayfun(@(indextime) dJold(indextime,:)*dJold(indextime,:).',1:length(tspan));
            deno = trapz(tspan,deno);
            beta  = max(0,nume/deno);
          case 'PR' % Polak-Ribi\'ere method
            nume = arrayfun(@(indextime) dJnew(indextime,:)*diffdJ(indextime,:).',1:length(tspan));
            nume = trapz(tspan,nume);
            deno = arrayfun(@(indextime) dJold(indextime,:)*dJold(indextime,:).',1:length(tspan));
            deno = trapz(tspan,deno);
            beta  = nume/deno;
          case 'HS' % Hestenes-Stiefel method
            nume = arrayfun(@(indextime) dJnew(indextime,:)*diffdJ(indextime,:).',1:length(tspan));
            nume = trapz(tspan,nume);
            deno = arrayfun(@(indextime) s(indextime,:)*diffdJ(indextime,:).',1:length(tspan));
            deno = trapz(tspan,deno);
            beta  = nume/deno;
          case 'DY' % Dai-Yuan method
            nume = arrayfun(@(indextime) dJnew(indextime,:)*dJnew(indextime,:).',1:length(tspan));
            nume = trapz(tspan,nume);
            deno = arrayfun(@(indextime) s(indextime,:)*diffdJ(indextime,:).',1:length(tspan));
            deno = trapz(tspan,deno);
            beta  = nume/deno;
          otherwise %'Popular choice': Positive Polak-Ribi\'ere.
            nume = arrayfun(@(indextime) dJnew(indextime,:)*diffdJ(indextime,:).',1:length(tspan));
            nume = trapz(tspan,nume);
            deno = arrayfun(@(indextime) dJold(indextime,:)*dJold(indextime,:).',1:length(tspan));
            deno = trapz(tspan,deno);
            beta  = max(0,nume/deno);
        end

        %
        s = - dJnew + beta*s;

        % Possible stopping criterion for constrainted control problems.
        % Call it using GradientMethod(...,'DescentParameters',{'StopCriteria','Jdiff'}).
        switch StopCriteria
          case 'relative'
            AdJnew = mean(abs(trapz(tspan,dJnew)));
            AUnew = mean(abs(trapz(tspan,Unew)));
            error = AdJnew/AUnew;
          case {'JDiff','Jdiff','jdiff'}
            % Stop when the difference of J is smaller than tol^2 + Jold*tol.
            error = (Jold-Jnew)/(Jold+tol);
          case 'absolute'
            error = AdJnew;
          otherwise
            AdJnew = mean(abs(trapz(tspan,dJnew)));
            AUnew = mean(abs(trapz(tspan,Unew)));
            error = AdJnew/AUnew;
        end
        
        if error < tol || OptimalLenght == 0 || abs(Jnew-Jold) < 1e-12
            stop = true;
        else 
            stop = false;
        end
    end
   

    function [Jsl ,varargout] = SearchLenght(LengthStep)
        
        Usl = Uold + LengthStep*s; 
        Usl = UpdateControlWithConstraints(iCP.constraints,Usl);
        %% Resolvemos el problem primal
        [~ , Ysl] = solve(iCP.dynamics,'Control',Usl);
        Jsl = GetNumericalFunctional(iCP,Ysl,Usl);

        if nargout > 1
           Psl  = GetNumericalAdjoint(iCP,Usl,Ysl);
           dJsl = GetNumericalControlGradient(iCP,Usl,Ysl,Psl);
           %
        
           dJda = arrayfun(@(indextime) dJsl(indextime,:)*dJsl(indextime,:).',1:length(tspan));
           dJda = -trapz(tspan,dJda);

           varargout{1} = dJda;
        end
    end
end

