function [x,t,u] = fractional_schr(s,L,Nx,T,u0)
%% author: UmbertoB
%% short_description: Localization along rays and propagation of the solution to the fractional wave equation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%% iu_t + (-d_x^2)^s u = 0,            (x,t) in (-L,L)x(0,T)         %%%%
%%%% u = 0,                              (x,t) in [R\(-L,L)]x(0,T)     %%%%
%%%% u(x,0) = u_0(x),                     x in (-L,L)                  %%%%
%%%%                                                                   %%%%
%%%% U. Biccari, April 2017                                            %%%%
%%%% v. 0.0                                                            %%%%
%%%%                                                                   %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% Input vars:
%
%    -  s   : Power of the fractional Laplacian.
%    -  L   : Size of the space interval.
%    -  Nx  : Number of points in the space mesh.
%    -  T   : Size of the time interval.
%    -  u0  : Inital funtion u0(x) / x in (-L,L)
%
%% Output Vars:
%    -  x   : Space partition
%    -  t   : Time partition
%    -  u   : matrix solution with dimension [ length(x) length(t) ]
%
    %%   Time and Space Intervals
    hx = (2*L)/(Nx+1);
    mu = 0.1;
    % CFL coefficient
    % The time interval depends directly by space time.
    ht = hx*mu; 
    % 
    %% Obtain the time and space number of points 
    % Size of matrix are lx -2, because delete boundury conditions

    t = 0 :ht:T; lt = length(t) ;
    x = -L:hx:L; lx = length(x) - 2;
    
    %% Resolution of the Schrodinger equation by the Crank-Nicholson scheme
    % 
    S = rigidity_fr_laplacian(s,L,lx);

    M = (2/3)*eye(lx);
    for i = 1:(lx-1)
        M(i,i+1) = 1/6;
        M(i+1,i) = 1/6;
    end
    M = hx*M;

    B1 = M + 1i*0.5*ht*S;
    B2 = M - 1i*0.5*ht*S;
    C = B1\B2;
    
    % Define inital condition 
    %   Allocate Memory
    u = zeros(lx,lt);
    %   Initial condition in first column
    u(:,1) = u0(x(2:end-1))';  
    % Evolution of solution
    for j = 2:lt
        u(:,j) = C*u(:,j-1);
    end
    
    %% Return only the module of solution
    u = abs(u);
    
    %% Add Boundary Conditions 
    % In this case, zeros in boundary
    u = [zeros(1,lt)  ; ...
           u          ; ...
           zeros(1,lt) ];

