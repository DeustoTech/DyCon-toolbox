clear all
close all
%% PDE definition
% ====================================================================================
N = 25;
xi = -1; xf = 1;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
dx = xline(2)-xline(1);
%% Matrix A y M
s = 0.8;
A = -FEFractionalLaplacian(s,1,N);
M = massmatrix(xline);
%% Matrix B
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "construction_matrix_B" (see below).
a = -0.3; b = 0.5;
B = construction_matrix_B(xline,a,b);
%%
% We can then define a final time and an initial datum
FinalTime = 0.4;
Y0 = cos(0.5*pi*xline');
%%
dt = 0.01;
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
dynamics.MassMatrix = M;
dynamics.mesh = xline;
%% Define adjoint problem
adjoint = pde('A',A);
adjoint.MassMatrix = M;
adjoint.mesh = xline;
adjoint.dt = dt;
adjoint.FinalTime = FinalTime;
%%
% ====================================================================================
% zeros 
YT = dynamics.Control.Numeric(1,:).';
%%
k = 1/(2*dx^3);
s = 175;
dx = xline(2) - xline(1);
%
Params.YT = YT;
Params.k  = k;
Params.s  = s;
Params.dx = dx;
Params.xline = xline;
Params.tspan = dynamics.tspan;
Params.B = dynamics.B;
Params.dynamics = dynamics;
Params.adjoint = adjoint;
%%
U0 = dynamics.Control.Numeric + 0.01;

[ ~  , Y0 ] = solve(dynamics,'Control',U0);
adjoint.InitialCondition = -k*(YT - Y0(end,:).');
[~ , P0]  = solve(adjoint);
dJ0 = dJfunctional(U0,Y0,P0,Params);
U = U0;
dJ = dJ0;
Y  = Y0;
J  = Jfunctional(U,Y,Params)

OptimalLenght = 0.00000001;

    figure('Unit','norm','Position',[0 0 1 1])
    subplot(1,4,1)
    surf(U)
    title('Control')
    subplot(1,4,2)
    surf(Y)
    title('State')
    subplot(1,4,3)
    plot([Y(end,:).',YT])
    ylim([-0.3 0.3])
    subplot(1,4,4)
    surf(dJ)
    title('Gradient')
    
    Jnew = Inf;
    
    options = optimoptions(@fminunc,'display','none');
for iter = 1:30000
    
%     funobj = @(alpha) alpha2J(alpha,dJ,U,Params);
%     seed = 10*OptimalLenght;
%     [OptimalLenght,Jnew] = fminunc(funobj,seed,options);
%     while Jnew > J
%         [OptimalLenght,Jnew] = fminunc(funobj,seed);
%         seed = rand*seed;
%     end
    %J = Jnew
    
    U = U - OptimalLenght*dJ;
    [ ~  , Y ] = solve(dynamics,'Control',U);
    J = Jfunctional(U,Y,Params)
    adjoint.InitialCondition = -k*(YT - Y(end,:).');
    [~ , P]  = solve(adjoint);
    P = flipud(P);
    
    dJ = dJfunctional(U,Y,P,Params);
    

    %%
    if mod(iter,20) == 0
    subplot(1,4,1)
    surf(U)
    title('Control')
    subplot(1,4,2)
    surf(Y)
    title('State')
    subplot(1,4,3)
    plot([Y(end,:).',YT])
    ylim([-0.3 0.3])
    subplot(1,4,4)
    surf(dJ)
    title('Gradient')

    pause(0.01)
    end
end


%%
%%
function J  = alpha2J(alpha,dJ,U,Params)
    dynamics = Params.dynamics;
    U = U - alpha*dJ;
    [ ~  , Y ] = solve(dynamics,'Control',U);
    J = Jfunctional(U,Y,Params);
end
function J = Jfunctional(U,Y,Params)
    xline = Params.xline;
    tspan = Params.tspan;
    s     = Params.s;
    k     = Params.k;
    YT    = Params.YT;
    if s == Inf
        dY = Y(end,:).'-YT;
        dY_norm_L2 = trapz(xline,abs(dY.').^2);
        
         J = 0.5*max(max(U))^2 + 0.5*k*dY_norm_L2;
    else
        
        U_norm_Ls = trapz(tspan,trapz(xline,abs(U.').^s));
        U_norm_Ls = U_norm_Ls.^(1/s);

        dY = Y(end,:).'-YT;
        dY_norm_L2 = trapz(xline,abs(dY.').^2);

        J = 0.5*U_norm_Ls^2 + 0.5*k*dY_norm_L2;
    end
end
%%
function dJ = dJfunctional(U,Y,P,Params)
    xline = Params.xline;
    tspan = Params.tspan;
    s     = Params.s;
    B     = Params.B;
    

    
    if s == Inf
        dJ = max(max(U))*sign(U) + P*B;
    else
    U_norm_Ls = trapz(tspan,trapz(xline,abs(U.').^s));
    U_norm_Ls = U_norm_Ls.^(1/s);
    U_norm_Ls = U_norm_Ls^(2-s);        
    dJ = U_norm_Ls*(U.*abs(U).^(s-2)) + P*B;
    end
    %dJ = -dJ;
end
%%
function M = massmatrix(mesh)
    N = length(mesh);
    dx = mesh(2)-mesh(1);
    M = 2/3*eye(N);
    for i=2:N-1
        M(i,i+1)=1/6;
        M(i,i-1)=1/6;
    end
    M(1,2)=1/6;
    M(N,N-1)=1/6;
            
    M=dx*sparse(M);
end
%%
function [B] = construction_matrix_B(mesh,a,b)

N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);
B = sparse(B);
end