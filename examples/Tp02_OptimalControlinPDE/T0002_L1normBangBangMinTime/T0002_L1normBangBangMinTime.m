
FinalTimes = linspace(0.5, 2,5);
JValues = arrayfun(@(FinalTime) OptiTime(FinalTime),FinalTimes);

plot(FinalTimes,JValues)
function J = OptiTime(FinalTime)
%% Discretization of the problem
Nx = 30;
Nt = 50;
xi = -1; xf = 1;
xline = linspace(xi,xf,Nx+2);
xline = xline(2:end-1);
dx = xline(2)-xline(1);
%% Take Matrix
s = 0.8;
A = -FEFractionalLaplacian(s,1,Nx);
M = massmatrix(xline);
%%
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "construction_matrix_B" (see below).
a = -0.3; b = 0.8;
B = BInterior(xline,a,b);
%%
% We can then define a final time and an initial datum
Y0 = 1+cos(pi*xline');
%%
dt = FinalTime/Nt;
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
dynamics.MassMatrix = M;
dynamics.mesh = xline;
%% Target 
YT = 1+sin(0.5*pi*xline');
YT = YT*0;
%% Calculate Free 
dynamics.InitialCondition = Y0;
U00 = dynamics.Control.Numeric*0;
solve(dynamics,'Control',U00);
%% 
% Take simbolic vars
Y = dynamics.StateVector.Symbolic;
U = dynamics.Control.Symbolic;
%%
epsilon = dx^4;
%%
Psi  = (dx/(2*epsilon))*(YT - Y).'*(YT - Y);
L    = (dx)*sum(abs(U));
%%
% Optional Parameters to go faster
Gradient                =  @(t,Y,P,U) dx*sign(U) + B*P;
Hessian                 =  @(t,Y,P,U) dx*eye(iCP.ode.Udim)*dirac(U);
AdjointFinalCondition   =  @(t,Y) (dx/(epsilon))* (Y-YT);
Adjoint = pde('A',A);
OCParmaters = {'Hessian',Hessian,'ControlGradient',Gradient,'AdjointFinalCondition',AdjointFinalCondition,'Adjoint',Adjoint};
%%
% build problem with constraints
iCP_norm_L1 =  Pontryagin(dynamics,Psi,L,OCParmaters{:});
%iCP_norm_L1.constraints.Umax =  20*max(Y0_other);
%iCP_norm_L1.constraints.Umin =  min(Y0_other);
iCP_norm_L1.constraints.Umax =  20;
iCP_norm_L1.constraints.Umin =  -20;
%
iCP_norm_L1.Target = YT;
%%
% Solver L1
Parameters = {'DescentAlgorithm',@ConjugateDescent, ...
             'tol',5e-2,                                    ...
             'Graphs',true,                               ...
             'MaxIter',500,                               ...
             'display','all',};
%%
GradientMethod(iCP_norm_L1,Parameters{:})
J = iCP_norm_L1.solution.Jhistory(end)
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
%% References
% 
% [1] U. Biccari and V. Hern\'andez-Santamar\'ia - \textit{Controllability 
%     of a one-dimensional fractional heat equation: theoretical and 
%     numerical aspects}, IMA J. Math. Control. Inf., to appear 
