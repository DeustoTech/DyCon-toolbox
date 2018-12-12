function [x,t,u] = fractional_schr(s,L,N,T,u0,varargin)

%% =========================================================================
% author: UmbertoB
%% =========================================================================
% date: 2017-04-01
%% =========================================================================
% short_description: Solver the fractional Schrodinger equation in 1d 
%% =========================================================================                  
% inputs_variables:  
%   s:
%       type:        double
%       dimension:   1
%       description: Order of the fractional Laplacian (-dx^2)^s
%       WARNING:     s HAS TO BE CHOSEN IN THE INTERVAL (0,1) 
%   L:
%       type:         double
%       dimension:    1
%       description:  Define the interval of x, So x \in (-L,L)  
%   N:
%       type:        integer
%       dimension:   1
%       description: number of points in the space discretization 
%   T:
%       type:        double
%       dimension:   1
%       description: length of the time interval
%   u0:
%       type:        function handle
%       dimension:   1
%       description: initial datum u0(x)
%% =========================================================================
% outputs_variables:
%   x:
%       type:        double
%       dimension:   1x(N+2)
%       description: space partition
%   t:
%       type:        double
%       dimension:   1xNt (Nt defined applying the CFL condition)
%       description: time partition
%   u:
%       type:        double
%       dimension:   NxNt
%       description: solution of the equation
%% =========================================================================
    
    p = inputParser;
    addRequired(p,'s',@valid_s)
    addRequired(p,'L')
    addRequired(p,'Nx')
    addRequired(p,'T')
    addRequired(p,'u0')
    
    parse(p,s,L,N,T,u0,varargin{:})
    
    %% Time and Space Intervals
    hx = (2*L)/(N+1);
    mu = 0.1; % CFL coefficient relating the space and time step.
              % It is needed since the Crank-Nicholson scheme is explicit.
    ht = hx*mu; 
     
    %% Obtain the time and space number of points 
    % Size of matrix are lx -2, because delete boundury conditions

    t = 0 :ht:T; lt = length(t) ;
    x = -L:hx:L; lx = length(x) - 2;
    
    %% Resolution of the Schrodinger equation by the Crank-Nicholson scheme
    
    S = rigidity_fr_laplacian(s,L,lx); % Rigidity matrix of the fractional
                                       % Laplacian 
    M = (2/3)*eye(lx);
    for i = 1:(lx-1)
        M(i,i+1) = 1/6;
        M(i+1,i) = 1/6;
    end
    M = hx*M; % Mass matrix of the FE scheme

    B1 = M + 1i*0.5*ht*S;
    B2 = M - 1i*0.5*ht*S;
    C = B1\B2; % Implementation matrix of the Crank-Nicholson scheme
    
    % Define inital condition 
    %   Allocate Memory
    u = zeros(lx,lt);
    %   Initial condition in first column
    u(:,1) = u0(x(2:end-1))';  
    % Evolution of solution
    for j = 2:lt
        u(:,j) = C*u(:,j-1);
    end
    
    %% Return only the module of solution (the full solution is complex)
    u = abs(u);
    
    %% Add Boundary Conditions 
    % In this case, zeros in boundary
    u = [zeros(1,lt)  ; ...
           u          ; ...
           zeros(1,lt) ];
end

function boolean = valid_s(s)
    if s >=1 || s <= 0 
        error('The parameter s needs to be in (0,1)')
    else
        boolean = true;
    end
end

