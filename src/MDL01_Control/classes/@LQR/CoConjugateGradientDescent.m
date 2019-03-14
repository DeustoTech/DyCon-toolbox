function  [fnew,dfnew,Unew ,Ynew,Jnew,dJnew,error,stop] = CoConjugateGradientDescent(iCP,tol,varargin)
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

    
    parse(p,iCP,tol,varargin{:})

    M = iCP.ode.MassMatrix;

    persistent Iter
    persistent w
    persistent ZeroInitialOde
    if isempty(Iter)
        %% Calculamos la dinamica libre 
        [~, Yfree] = solve(iCP.ode);
        %% Creamos otra ode igual que la primal pero con condicion inicial cero
        ZeroInitialOde = copy(iCP.ode);
        ZeroInitialOde.InitialCondition = ZeroInitialOde.InitialCondition*0;
        %% Resolvemos el problema adjunto con la semilla 
        fnew = iCP.solution.fhistory{1};
        % Obtenemos el adjunto con condicion final fnew
        iCP.adjoint.ode.InitialCondition = fnew;
        P = GetNumericalAdjoint(iCP);
        
        %% Calculamos U a partir de la solucion del adjunto
        Unew = P*iCP.ode.B;
        
        %% Obtenemos la dinamica
        [~ , YZeroInitial] = solve(ZeroInitialOde,'Control',Unew);
        %

        %% obtenemos el gradiente
        dfnew = iCP.epsilon*fnew + YZeroInitial(end,:) + Yfree(end,:);
        % tomamo w = df
        
        w = dfnew;
        %%
        [~ , Ynew] = solve(iCP.ode,'Control',Unew);
        Jnew = GetFunctional(iCP,Ynew,Unew);
        
        Iter = 1;
        error = 0;
        dJnew = Unew;
        stop = false;

    else
        Iter = Iter + 1;
        %% Resolvemos el problem dual
        %display(norm(w))
        iCP.adjoint.ode.InitialCondition = w;
        P = GetNumericalAdjoint(iCP);


        %% Calculamos U
        Unew = P*iCP.ode.B;
        
        %% Obtenemos la dinamica
        [~ ,YZeroInitial] = solve(ZeroInitialOde,'Control',Unew);

        fold   = iCP.solution.fhistory{Iter-1};
        dfold  = iCP.solution.dfhistory{Iter-1};
        
        %% Actualizamos el gradiente
        %display(norm(YZeroInitial(end,:)))
        dfbar = iCP.epsilon*w + YZeroInitial(end,:);
        
        rho = (dfold*M*dfold')/(dfbar*M*w');
        
        dfnew = dfold -rho*dfbar;
        fnew  = fold - rho*w;
        %%

        gamma = (dfnew*M*dfnew')/(dfold*M*dfold');
        w = dfnew + gamma*w;
        
        %%
        iCP.adjoint.ode.InitialCondition = fnew;
        P = GetNumericalAdjoint(iCP);

        Unew = P*iCP.ode.B;
        
        [~ , Ynew] = solve(iCP.ode,'Control',Unew);
        
        %%
        %Ynew = YZeroInitial;
        %dJnew= 1;
        %Jnew = 1;
        %%
        dJnew = GetNumericalGradient(iCP,Unew,Ynew);        
        Jnew  = GetFunctional(iCP,Ynew,Unew);
                
        error = sqrt(dfnew*M*dfnew');
        display(["error = "+error]);

        if error < tol 
            stop = true;
        else 
            stop = false;
        end

    end
end
