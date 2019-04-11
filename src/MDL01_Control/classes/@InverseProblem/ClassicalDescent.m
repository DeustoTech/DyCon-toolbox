function  [Y0new ,Ynew,Pnew,Jnew,dJnew,error,stop] = ClassicalDescent(iCP,tol,varargin)
%  description: This method is used within the GradientMethod method. GradientMethod executes iteratively this rutine in 
%                 order to get one update of the control in each iteration. In the case of choosing ClassicalDescent this function 
%                 updates the control of the following way
%                 $$u_{old}=u_{new}-\alpha dJ$$
%                 where dJ is an approximation of the gradient of J that has been obtained considering the adjoint state of the 
%                 optimality condition of Pontryagin principle. The optimal control problem is defined by
%                 $$\min J=\min\Psi (t,Y(T))+\int^T_0 L(t,Y,U)dt$$
%                 subject to
%                 $$\frac{d}{dt}Y=f(t,Y,U)$$
%                 The gradient of $J$ is
%                 $$dJ=\partial_u H=\partial_uL+p\partial_uf$$
%                 An approximation $p$ is computed using
%                 $$-\frac{d}{dt}p = f_Y (t,Y,U)p+L_Y(Y,U)$$
%                 $$ p(T)=\psi_Y(Y(T))$$
%                 Since one the expression of the gradient, we can start with an initial control, 
%                 solve the adjoint problem and evaluate the gradient. Then we will update the initial control in 
%                 the direction of the approximate gradient with a step size $\alpha$.
%                 In this routine the user has to choose the step size.
%                 WARNING Using this routine the GradientMethod might not converge if the stepsize is not choosen properly or
%                 being slow if the step size is choosen very small. For an adaptative stepsize with Armijo Rule guaranteeing the
%                 convergence see (adaptative stepsize).
%                 This routine will tell to GradientMethod to stop when the minimum tolerance of the derivative 
%                 (or the relative error, user's choice) is reached. Moreover there is a maximum of iterations allowed.
%  little_description: GradientMethod executes iteratively this rutine in 
%                       order to get one update of the control in each iteration. 
%                       In the case of choosing ClassicalDescent this function 
%               updates the control
%  autor: [DomenecR,JOroya]
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
%        description: This parameter is the length step of the gradient method that is going to be used. By default, this is 0.1.
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

    addOptional(p,'LengthStep',0.001)
   
    parse(p,iCP,tol,varargin{:})

    LengthStep = p.Results.LengthStep;
    
    persistent Iter
    persistent seed
    
    if isempty(Iter)
        Y0new = iCP.solution.Y0history{1};
        %
        iCP.dynamics.InitialCondition = Y0new;

        [~,Ynew] = solve(iCP.dynamics);
        iCP.adjoint.dynamics.InitialCondition = iCP.adjoint.FinalCondition(Ynew(end,:));
        [~ , Pnew] = solve(iCP.adjoint.dynamics);
        Pnew = flipud(Pnew); 
        dJnew = Pnew(1,:) + 0.05*sign(Ynew(1,:)) ;

        %
        Jnew = 0.5*trapz(iCP.dynamics.mesh, (iCP.FinalState - Y0new(end,:)).^2);
        Iter = 1;
        error = 0;
        stop = false;
        seed = 1;
        
    else
        Iter = Iter + 1;
        
        Uold  = iCP.solution.Uhistory{Iter-1};
        Yold  = iCP.solution.Yhistory{Iter-1};
        Y0old  = iCP.solution.Y0history{Iter-1};

        Pold  = iCP.solution.Phistory{Iter-1};
        dJold  = iCP.solution.dJhistory{Iter-1};

        Jold  = iCP.solution.Jhistory(Iter-1);
        %% Actualizamos  Control
        Jnew = Jold + 1;
        options = optimoptions(@fminunc,'SpecifyObjectiveGradient',false,'Display','off','Algorithm','quasi-newton','CheckGradients',false);

        while Jnew > Jold 
            [OptimalLenght,Jnew] = fminunc(@SearchLenght,seed,options);
            if abs(OptimalLenght) < 1e-60
                warning('The Optimal Lenght Step is cero.')
                Jnew = Jold;
                OptimalLenght = 0;
                
            end
            seed = 0.1*seed;
        end
        %options = optimoptions(@fminunc,'SpecifyObjectiveGradient',true,'Display','off','Algorithm','quasi-newton','CheckGradients',false);
        %options = optimoptions(@fminunc,'SpecifyObjectiveGradient',true,'Display','off','Algorithm','trust-region','CheckGradients',false);
        %options = optimoptions(@fminunc,'SpecifyObjectiveGradient',false,'Display','off','Algorithm','quasi-newton','CheckGradients',false);

        %[OptimalLenght,Jnew] = fminunc(@SearchLenght,0,options);
        Y0new = Y0old - OptimalLenght*dJold; 
        Y0new = UpdateControlWithConstraints(iCP.constraints,Y0new);
        %% Resolvemos el problem primal
        iCP.dynamics.InitialCondition = Y0new;
        [~ ,Ynew] = solve(iCP.dynamics);
        
        %%
        iCP.adjoint.dynamics.InitialCondition = iCP.adjoint.FinalCondition(Ynew(end,:));
        [~ , Pnew] = solve(iCP.adjoint.dynamics);
        Pnew = flipud(Pnew); 
        dJnew = Pnew(1,:) +  0.05*sign(Ynew(1,:));
        
        
        mesh = iCP.dynamics.mesh;
        AdJnew = mean(abs(trapz(mesh,dJnew)));
        AUnew = mean(abs(trapz(mesh,Y0new)));
        error = AdJnew/AUnew;
        if error < tol || OptimalLenght == 0
            stop = true;
        else 
            stop = false;
        end
    end
    function [Jsl,varargout] = SearchLenght(LengthStep)
      

        Usl = Y0old - LengthStep*dJold; 
        Usl = UpdateControlWithConstraints(iCP.constraints,Usl);

        %% Resolvemos el problem primal
        iCP.dynamics.InitialCondition = Usl;

        [~ ,Ysl] = solve(iCP.dynamics);
        Jsl = 0.5*trapz(iCP.dynamics.mesh, (iCP.FinalState - Ysl(end,:)).^2);

        
        if nargout > 1
           Psl  = GetNumericalAdjoint(iCP,Usl,Ysl);
           dJsl = GetNumericalControlGradient(iCP,Usl,Ysl,Psl);
           %
           %dJda  = (trapz(tspan,sum(dJsl.*s,2)));
           dJda = -arrayfun(@(indextime) dJsl(indextime,:)*dJnew(indextime,:).',1:length(iCP.dynamics.tspan));
           dJda = trapz(iCP.dynamics.tspan,dJda);
           
           
           varargout{1} = dJda;
        end
    end
end
