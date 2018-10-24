function [u,aditional_data] = solve_CG(ACProblem,xt,varargin)
%SOLVE_CG Summary of this function goes here
%   Detailed explanation goes here
    %% Variables 
    
    p = inputParser;
    addRequired(p,'ACProblem')
    addRequired(p,'xt')
    addOptional(p,'tol',1e-8)
    addOptional(p,'beta',1e-3)
    addOptional(p,'MaxIter',50)
    
    parse(p,ACProblem,xt,varargin{:})

    tol     = p.Results.tol;
    beta    = p.Results.beta;
    MaxIter = p.Results.MaxIter;

    N = ACProblem.N;
    K = ACProblem.K;
    A = ACProblem.A;
    B = ACProblem.B;
    span = ACProblem.span;
    T0 = span(1); T = span(end);
    u = ACProblem.u0;
    x0 = ACProblem.x0;
    %% init
    tic;
    %%
     primal_odes = zeros(1,ACProblem.K,'ode');
    for index = 1:K
        %
        primal_odes(index)      = ode(A(:,:,index),'B',B(:,:,index));
        % all have the same control
        primal_odes(index).u    = ACProblem.u0;
        % time intervals
        primal_odes(index).span = span;
        % initial state
        primal_odes(index).x0   = ACProblem.x0;
    end

    %
    adjoint_odes = zeros(1,K,'ode');
    for index = 1:K
        adjoint_odes(index)      = ode(A(:,:,index)');
        % all have the same control
        adjoint_odes(index).u    = ACProblem.u0;
        % time intervals
        adjoint_odes(index).span = span;
    end
   
    %%
    % Compute b in gradient = A*u-b for CG method
    % Free dynamics solution
    
    solve(primal_odes)
    xMend = forall({primal_odes.xend},'mean');
    
    % solve adjoints problems
    % =======================
    % update new initial state of all adjoint problems
    for iode = adjoint_odes
        iode.x0 = -(xMend' - xt);
    end
    % solve adjoints problems with the new initial state
    solve(adjoint_odes);

    % update control
    % ===============
    % calculate mean state vector of adjoints problems 
    pM = adjoint_odes(1).x*B(:,:,1);
    for index =2:K
        pM = pM + adjoint_odes(index).x*B(:,:,index);
    end
    pM = pM/K;
    % reverse adjoint variable
    b = -flipud(pM);   
        
    % Compute A*u
    % Zero initial condition solution
    zT = primal(u, A, B, zeros(N, 1), span);
    Au = dual(zT, A, B, span) + beta*u;

    % Compute initial gradient and store previous gradient
    g =  Au - b;

    % Initial gradient norm
    g0L2 = trapz(span, g.^2);
    gL2 = g0L2;

    % Residual b-A*u
    r = -g;
    % Residual norm
    rn = sqrt( integral(@(t) interp1(span, r, t).^2, T0, T) );
    uhistory = {};  rnhistory = zeros(1,MaxIter);    % array here we will save the evolution of average vector states

    iter = 0;
    while (rn > tol && iter <= MaxIter)

        % A*u
        zT = primal(r, A, B, zeros(N, 1), span);
        w = dual(zT, A, B, span) + beta*r;

        % alpha
        alpha = trapz(span,g.^2) / trapz(span,r.*w);

        % Update control
        u = u + alpha*r;

        % Store previous gradient
        gaL2 = gL2;
        % Update gradient
        g = g + alpha*w;
        % Compute gradient norm
        gL2 = trapz(span, g.^2);

        % gamma
        gamma = gL2/gaL2;

        % Update residual
        r = -g + gamma*r;

        % Compute residual norm
        rn = sqrt(trapz(span, r.^2));

        % Update iteration counter
        iter = iter + 1;
        % Save evolution
        uhistory{iter} = [ span',u]; 
        rnhistory(iter) = rn;

    end
    aditional_data.uhistory = uhistory;
    aditional_data.error_history = rnhistory;
    aditional_data.time_execution = toc;

end
function [pM] = dual(p0, A, B, tout)

% dualApp receives the adjoint state at time t = T and returns the dual 
% solutions average in the parameter space

% Number of time steps
Nt = length(tout);
% Size of parameter space
M = size(A, 3);

% Adjoint variable average: 1/N*sum_i(B*pout(t, nu(i)))
pM = zeros(Nt, 1);
% Solve adjoint problem forward in time for every parameter in nu
for j = 1:M   
    % Update matrix A
    Am = A(:, :, j);
    % Update matrix B
    Bm = B(:, :, j);
    % Solve adjoint problem forward in time
    [tout, pout] = ode45(@(t, p) Am'*p, tout, -p0); 
    pM = pM + pout*Bm;
end
pM = -pM/M;

% Reverse adjoint variable in time
pM = flipud(pM);

end

function [zMT,zM] = primal(u, A, B, z0, tout)

% primalApp receives the control vector and returns the primal solutions
% average in the parameter space at time t = T

% Number of time steps
Nt = length(tout);
% Size of parameter space
M = size(A, 3);

% Average of primal solutions
zM = zeros(Nt, 1);
% Solve primal problem for every parameter in nu
for j = 1:M
    % Update matrix A
    Am = A(:, :, j);
    % Update matrix B
    Bm = B(:, :, j);
    % Primal problem zdiff = A*z + B*u
    [tout, zout] = ode45(@(t, z) Am*z + Bm*interp1(tout, u, t), tout, z0);
    % Save final state for parameter nu(j)
    % zend(j, :) = zout(end, :);
    % Update average state
    zM = zM + zout; 
end
% Update average state
zM = zM/M;

zMT = zM(end, :)';
    
end

