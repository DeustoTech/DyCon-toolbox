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

    addOptional(p,'LengthStep',0.1)
   
    parse(p,iCP,tol,varargin{:})

    LengthStep = p.Results.LengthStep;
    stop = false;
    
    persistent Iter
    persistent w
    if isempty(Iter)
        fnew = iCP.solution.fhistory{1};

        tspan   =  iCP.ode.tspan; 
        %% Resolvemos el problem dual
        % Creamos dp/dt (t,p)  a partir de la funcion dp_dt_xuDepen
        dP_dt  = @(t,P) -iCP.ode.A'*P;
        % Obtenemos la condicion final del problema adjunto
        % Resolvemos el problema dual, colcando un 
        % signo negativo y luego inviertiendo en el tiempo la solucion
        solver = iCP.ode.RKMethod;
        [~,P] = solver(@(t,P) -dP_dt(t,P),tspan,fnew);
        P = flipud(P);
        % Obtenemos la funcion p(t) a partir p = [p(t1) p(t2) ... ]
        %% Calculamos U
        solution = solve(iCP.gradient.sym == 0,iCP.ode.Control.Symbolic);
        %
        U = arrayfun(@(u) solution.(u{:}),fieldnames(solution));
        Unew = zeros(length(P(:,1)),iCP.ode.Udim);
        for nrow = 1:length(P(:,1))
           Unew(nrow,:) =double(subs(U,iCP.adjoint.P,P(nrow,:))');
        end
        %% Obtenemos la dinamica
        solve(iCP.ode,'Control',Unew);
        %
        Ynew = iCP.ode.VectorState.Numeric;
        Jnew = GetFunctional(iCP,Ynew,Unew);
        Iter = 1;
        error = 0;
        dJnew = Unew;
        dfnew = fnew + Ynew(end,:);
        w = dfnew;
        stop = false;
    else
        Iter = Iter + 1;
        tspan   =  iCP.ode.tspan;
 
        %% Resolvemos el problem dual
        % Creamos dp/dt (t,p)  a partir de la funcion dp_dt_xuDepen
        dP_dt  = @(t,P) -iCP.ode.A'*P;
        % Obtenemos la condicion final del problema adjunto
        % Resolvemos el problema dual, colcando un 
        % signo negativo y luego inviertiendo en el tiempo la solucion
        solver = iCP.ode.RKMethod;
        [~,P] = solver(@(t,P) -dP_dt(t,P),tspan,w);
        P = flipud(P);
        % Obtenemos la funcion p(t) a partir p = [p(t1) p(t2) ... ]
    
        solution = solve(iCP.gradient.sym == 0,iCP.ode.Control.Symbolic);
        %
        U = arrayfun(@(u) solution.(u{:}),fieldnames(solution));
        Unew = zeros(length(P(:,1)),iCP.ode.Udim);
        for nrow = 1:length(P(:,1))
           Unew(nrow,:) =double(subs(U,iCP.adjoint.P,P(nrow,:))');
        end
        %% Obtenemos la dinamica
        solve(iCP.ode,'Control',Unew);
        Ynew = iCP.ode.VectorState.Numeric;
        dfbar = w + Ynew(end,:);
        
        rho = (dfbar*dfbar')/(dfbar*w');
 
        
        fold  = iCP.solution.fhistory{Iter-1};
        dfold  = iCP.solution.dfhistory{Iter-1};
        
        fnew = fold - rho*w;
        dfnew = dfold -rho*dfbar;
        
        
        %%
        
        error = 1;
        if error < tol
            stop = true;
        else 
            stop = false;
        end
        dJnew = 1;
        Jnew = GetFunctional(iCP,Ynew,Unew);
    end
end
