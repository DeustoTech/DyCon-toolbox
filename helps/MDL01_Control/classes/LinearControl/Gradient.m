function results = Gradient(iLinearControl,varargin)
%CLASSICALGRADIENT Summary of this function goes here
%   Detailed explanation goes here
    p = inputParser;
    
    addRequired(p,'iLinearControl')
    %
    addOptional(p,'maxiter',100)
    addOptional(p,'beta',0.01)
    addOptional(p,'tol',0.001)


    parse(iLinearControl,varargin{:})
    
    maxiter = p.Results.maxiter;
    beta    = p.Results.beta;
    tol     = p.Results.tol;
    
    A = iLinearControl.A;
    tspan = iLinearControl.tspan;
    u0 = iLinearControl.u0;
    
    N       = length(A(:,1));
    %% Init
    Jhistory = zeros(maxiter,N);
    Thetahistory = zeros(N,length(tspan),maxiter);
    uhistory = zeros(length(tspan),N,maxiter);
    %%
    Jb = Inf;
    tic;
    u = u0;
    for iter = 1:maxiter
        %% Primal problem
        fun_primal     = @(t,theta) A*theta + arrayfun(@(ncol) interp1(tspan,u(:,ncol),t),1:N)';
        [tspan, theta] = ode45(fun_primal,tspan,theta0);

        %% Adjoint problem
        % p'(t,p) = A*p
        fun_adjoint = @(t,p)  A'*p;
        % Choose Initial Condition
        thetaT = theta(end,:)';

        p = zeros(length(tspan),N,N);
        for j = 1:N
            %
            p0 =   repmat(thetaT(j)',N,1) - thetaT;
            % Solve the adjoint problem 
            [tspan, p(:,:,j)] = ode45(fun_adjoint,tspan,p0);
            p(:,:,j) = flipud(p(:,:,j));
        end

        % Update Control
        nk = 1/sqrt(iter);

        sump = p(:,:,1);
        for k = 2:N 
            sump = sump +p(:,:,k);
        end
        sump = sump/N;

        u = u - nk*(beta*u-sump);
        %%
        % Stop Condition
        J = Jfunctional(u,tspan,thetaT,beta);
        if sum((Jb-J).^2) <= tol
            break
        else
            Jb = J;
            Jhistory(iter,:) =  J';
            Thetahistory(:,:,iter) = theta';
            uhistory(:,:,iter) = u;
        end
        %%
    end
    %% damos formato a la salida
    results.t = toc;
    results.Jhistory     = Jhistory(1:iter-1);
    results.Thetahistory = Thetahistory(:,:,1:iter-1);
    results.uhistory     = uhistory(:,:,1:iter-1);
    results.iters        = iter-1;
    results.N            = N;
    results.tspan        = tspan;

end

function Jis = Jfunctional(u,tspan,thetaT,beta)
    N = length(thetaT);
    Jis = zeros(length(thetaT),1);
    index = 0;
    for ithetaT = thetaT'
        index = index + 1;
        sum = 0;
        for jthetaT = thetaT'
            sum = sum + (jthetaT-ithetaT).^2;
        end
        Jis(index) = (0.5/N)*sum + 0.5*beta*trapz(tspan,u(:,index).^2);
    end
end
