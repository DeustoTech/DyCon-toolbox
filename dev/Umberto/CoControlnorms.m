clear all
close all
%% PDE definition
% ====================================================================================
N = 50;
xi = -1; xf = 1;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
dx = xline(2)-xline(1);
%% Matrix A y M
s = 0.5;
A = -FEFractionalLaplacian(s,1,N);
M = massmatrix(xline);
%% Matrix B
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "construction_matrix_B" (see below).
a = -0.3; b = 0.2;
B = construction_matrix_B(xline,a,b);
%%
% We can then define a final time and an initial datum
FinalTime = 0.3;
%%
Y0 = cos(0.5*pi*xline');
%%
Nt = 50;
dt = FinalTime/Nt;
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
dynamics.MassMatrix = M;
dynamics.mesh = xline;
%%
FreeDynamics = copy(dynamics);
FreeDynamics.label = 'Free';
solve(FreeDynamics);
%% Define adjoint problem
adjoint = pde('A',A);
adjoint.MassMatrix = M;
adjoint.mesh = xline;
adjoint.dt = dt;
adjoint.FinalTime = FinalTime;
%% Constantes
Params.k  = 1/(dx^4);
Params.s  = Inf;
Params.sp = 1;
Params.dx = dx;
Params.xline = xline;
Params.tspan = dynamics.tspan;
Params.B = dynamics.B;
Params.dynamics = dynamics;
Params.adjoint = adjoint;

%% Caso 1: 
% ====================================================================================
% zeros 
Params.YT = 2*Y0;
Params.Umax = 10000*max(Params.YT);
Params.Umin = 0;
Params.dynamics.label = 'Controlada';
OptimalLenght = 1e-6;
MaxIter = 1000;
[U,Y,J] = ClassicalDescent(Params,OptimalLenght,MaxIter);
%%
%% Caso 2: 
% ====================================================================================
% Params.YT = 1/2*Y0;
% Params.Umax = max(Params.YT);
% Params.Umin = 0;

% Params.dynamics.label = 'Controlada'; 
% MaxIter = 1000;
% OptimalLenght = 1e-6;
% [U,Y,J] = ClassicalDescent(Params,OptimalLenght,MaxIter);

function [U,Y,J] = ClassicalDescent(Params,OptimalLenght,MaxIter)
    f0 = zeros(length(Params.adjoint.StateVector.Symbolic),1);
    f = f0 +1;
    %%
    %%
    Params.adjoint.InitialCondition = f;
    [~ , P ] = solve(Params.adjoint);
    P = flipud(P);

    U = Adjoint2Control(P,Params);
    [ ~  , Y ] = solve(Params.dynamics,'Control',U);
    dJ = dJfunctional(f,Y,Params);

    J  = Jfunctional(U,Y,Params)


    for iter = 1:MaxIter

        f = f - OptimalLenght*dJ;
        Params.adjoint.InitialCondition = f;
        [~ ,P ] = solve(Params.adjoint);
        P = flipud(P);

        U = Adjoint2Control(P,Params);

        [ ~  , Y ] = solve(Params.dynamics,'Control',U);
        dJ = dJfunctional(f,Y,Params);

        J  = Jfunctional(U,Y,Params)

    end
    
end
%%
function U = Adjoint2Control(P,Params)
    sp = Params.sp;
    xline = Params.xline;
    tspan = Params.tspan;
    B     = Params.B;
    
    if sp ~= 1
        P_norm_Ls = trapz(tspan,trapz(xline,abs(P.').^sp));
        P_norm_Ls = P_norm_Ls.^(1/sp);
        P_norm_Ls = P_norm_Ls^(2-sp); 

        U = -P_norm_Ls*(P.*(abs(P).^(sp-2)))*B;
    else
        P_norm_L1 = trapz(tspan,trapz(xline,abs(P.')));
        U = -P_norm_L1*(sign(P)*B);
    end
    
    U(U>Params.Umax) = Params.Umax;
    U(U<Params.Umin) = Params.Umin;
end
%%

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
function dJ = dJfunctional(f,Y,Params)

    k = Params.k;
    YT = Params.YT;
    %%
    dJ = +f + k*(YT-Y(end,:)');

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