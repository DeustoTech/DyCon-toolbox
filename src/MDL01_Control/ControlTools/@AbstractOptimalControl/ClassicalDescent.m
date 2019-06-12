function  [ControlNew ,Ynew,Pnew,Jnew,dJnew,error,stop] = ClassicalDescent(iCP,tol,tolU,tolJ,varargin)
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
%        description: the tolerance desired, for gradient of cost functions.  
%        class: double
%        dimension: [1x1]
%    tolU: 
%        description: the tolerance desired, for relative difference of control functions.  
%        class: double
%        dimension: [1x1]
%    tolJ: 
%        description: the tolerance desired, for relative difference of cost functions.  
%        class: double
%        dimension: [1x1]
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
    addRequired(p,'tolU')
    addRequired(p,'tolJ')

    addOptional(p,'LengthStep',0.001)
    addOptional(p,'FixedLengthStep',false)

    parse(p,iCP,tol,tolU,tolJ,varargin{:})

    LengthStep      = p.Results.LengthStep;
    FixedLengthStep = p.Results.FixedLengthStep;

    persistent Iter
    persistent seed
    
    if isempty(Iter)
        ControlNew = iCP.Solution.ControlHistory{1};
        %
        [Jnew,dJnew,Ynew,Pnew] = Control2Functional(iCP,ControlNew);
        % 
        Iter = 1;
        error = 0;
        stop = false;
        seed = LengthStep;
        
    else
        Iter = Iter + 1;
        
        ControlOld  = iCP.Solution.ControlHistory{Iter-1};
        Jold  = iCP.Solution.Jhistory(Iter-1);
        dJold = iCP.Solution.dJhistory{Iter-1};
        
        %% Search Optimal Lentgh
        if FixedLengthStep
            OptimalLenght = LengthStep;
        else          
            options = optimoptions(@fminunc,'SpecifyObjectiveGradient',false,'Display','off','Algorithm','quasi-newton','CheckGradients',false);
            Jnew = Jold + 1;
            while Jnew > Jold 
                [OptimalLenght,Jnew] = fminunc(@SearchLenght,seed,options);
                if OptimalLenght < 1e-20
                    warning('The Optimal Lenght Step is cero.')
                    Jnew = Jold;
                    OptimalLenght = 0;
                end
                seed = 0.1*seed;
            end            
        end
        
        %% Update Control
        ControlNew = ControlOld - OptimalLenght*dJold; 
        ControlNew = UpdateControlWithConstraints(iCP.Constraints,ControlNew);
        
        %% Calculate new functional, adjoint, state, gradient
        [Jnew,dJnew,Ynew,Pnew] = Control2Functional(iCP,ControlNew);
        
        %%
        error = norm(dJnew)/norm(ControlNew);
        if error < tol || OptimalLenght == 0 || norm(ControlNew - ControlOld)/(norm(ControlOld)+tolU) <tolU || abs(Jnew-Jold)/(Jold+tolJ) < tolJ
            stop = true;
        else 
            stop = false;
        end
    end
    
    
    
    
    
    %%
    %%
    %%
    %%
    function Jsl = SearchLenght(LengthStep)
        
        Usl = ControlOld - LengthStep*dJold; 
        Usl = UpdateControlWithConstraints(iCP.Constraints,Usl);

        Jsl = Control2Functional(iCP,Usl);
    end
end
