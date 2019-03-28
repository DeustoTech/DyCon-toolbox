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
s = 0.8;
A = -FEFractionalLaplacian(s,1,N);
M = massmatrix(xline);
%% Matrix B
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "construction_matrix_B" (see below).
a = -0.3; b = 0.8;% Params.YT = YT';
% Params.Umax = 50*max(Params.YT);
% Params.Umin = 0*max(Params.YT);
% 
% Params.dynamics.label = 'Controlada'; 
% MaxIter = 2000;
% f0 = zeros(length(Params.adjoint.StateVector.Symbolic),1);
% f = f0 +0.1;
% OptimalLenght = 1e-6;
% [U,Y,J,f] = ClassicalDescent(Params,OptimalLenght,MaxIter,f);

B = construction_matrix_B(xline,a,b);
%%
% We can then define a final time and an initial datum
FinalTime = 1;
%%
Y0 = 2*cos(0.5*pi*xline');
Y00 = cos(0.5*pi*xline');
% Y0 = 0.5*cos(0.5*pi*xline');
% Y00 = 3*cos(0.5*pi*xline');
%%
Nt = 50;
dt = FinalTime/Nt;
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
dynamics.MassMatrix = M;
dynamics.mesh = xline;
%%
TargetDynamics = copy(dynamics);
TargetDynamics.InitialCondition = Y00;
RightHandSide = 0*TargetDynamics.Control.Numeric+1;
RightHandSide = RightHandSide*B;
[~,YT] = solve(TargetDynamics,'Control',RightHandSide);
YT = YT(end,:);
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
% Params.YT = YT';
% % Params.Umax = 1000000*max(Params.YT);
% % Params.Umin = -1000000*max(Params.YT);
% 
% Params.Umax = 2;
% Params.Umin = 0*max(Params.YT);
% 
% Params.dynamics.label = 'Controlada';
% OptimalLenght = 1e-6;
% MaxIter = 2000;
% f0 = zeros(length(Params.adjoint.StateVector.Symbolic),1);
% f = f0 +0.5;
% [U,Y,J,f] = ClassicalDescent(Params,OptimalLenght,MaxIter,f);
% 
% OptimalLenght = 1e-8;
% MaxIter = 2000;
% [U,Y,J,f] = ClassicalDescent(Params,OptimalLenght,MaxIter,f);
% 
% OptimalLenght = 1e-12;
% MaxIter = 1000;
% [U,Y,J,f] = ClassicalDescent(Params,OptimalLenght,MaxIter,f);
%%
%% Caso 2: 
% ====================================================================================
Params.YT = YT';
Params.Umax = 2;
Params.Umin = 0*max(Params.YT);

% Params.Umax = 50000000*max(Params.YT);
% Params.Umin = -50000000*max(Params.YT);

Params.dynamics.label = 'Controlada'; 
MaxIter = 2000;
f0 = zeros(length(Params.adjoint.StateVector.Symbolic),1);
f = f0 +0.1;
OptimalLenght = 1e-6;
[U,Y,J,f] = ClassicalDescent(Params,OptimalLenght,MaxIter,f);

MaxIter = 2000;
OptimalLenght = 1e-9;
[U,Y,J,f] = ClassicalDescent(Params,OptimalLenght,MaxIter,f);

function [U,Y,J,f] = ClassicalDescent(Params,OptimalLenght,MaxIter,f)
    %f0 = zeros(length(Params.adjoint.StateVector.Symbolic),1);
    %f = f0 +0.1;
    %%
    %%
    Params.adjoint.InitialCondition = f;
    [~ , P ] = solve(Params.adjoint);
    P = flipud(P);

    U = Adjoint2Control(P,Params);
    [ ~  , Y ] = solve(Params.dynamics,'Control',U);
    dJ = dJfunctional(f,Y,Params);

    J  = Jfunctional(U,Y,Params)

    bestJ = Inf;
    for iter = 1:MaxIter

        f = f - OptimalLenght*dJ;
        Params.adjoint.InitialCondition = f;
        [~ ,P ] = solve(Params.adjoint);
        P = flipud(P);

        U = Adjoint2Control(P,Params);

        [ ~  , Y ] = solve(Params.dynamics,'Control',U);
        dJ = dJfunctional(f,Y,Params);

        J  = Jfunctional(U,Y,Params)
        if J < bestJ
            bestJ = J;
            bestf = f;
        end
    end
    Params.adjoint.InitialCondition = bestf;
        [~ ,P ] = solve(Params.adjoint);
        P = flipud(P);

        U = Adjoint2Control(P,Params);

        [ ~  , Y ] = solve(Params.dynamics,'Control',U);
        J = bestJ;
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