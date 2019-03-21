%% 
% We use DyCon Toolbox for solving numerically the following control 
% problem: given any $T>0$, find a control function $g\in L^2( ( -1 , 1) \times (0,T))$ 
% such that the corresponding solution to the parabolic problem
%%
% $$
% \begin{equation}\label{frac_heat}
%   \begin{cases}
%       z_t+(d_x^2)^s z = g\chi_\omega, & (x,t)\in(-1,1)\times(0,T) \\
%       z = 0, & (x,t)\in[\mathbb{R}\setminus(-1,1)]\times(0,T) \\
%       z(x,0) = z_0(x), & x\in(-1,1)
%   \end{cases}
% \end{equation} $$
%%
% satisfies $z(x,T)=0$.
%%
% Here, for all $s\in(0,1)$, $(-d_x^2)^s$ denotes the one-dimensional 
% fractional Laplace operator, defined as the following singular integral
%%
% $$
% \begin{equation*}
%   (-d_x^2)^s z(x) = c_s P.V. \int_{\mathbb{R}}
%   \frac{z(x)-z(y)}{|x-y|^{1+2s}}\,dy.
% \end{equation*} $$
%% Discretization of the problem
% As a first thing, we need to discretize \eqref{frac_heat}. 
% Hence, let us consider a uniform N-points mesh on the interval $(-1,1)$.
%clear
N = 100;
xi = -1; xf = 1;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
dx = xline(2)-xline(1);
%%
% Out of that, we can construct the FE approxiamtion of the fractional
% Lapalcian, using the program FEFractionalLaplacian developped by our
% team, which implements the methodology described in [1].
%%
s = 0.8;
A = -FEFractionalLaplacian(s,1,N);
M = massmatrix(xline);
%%
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "construction_matrix_B" (see below).
a = -0.3; b = 0.8;
B = construction_matrix_B(xline,a,b);
%%
% We can then define a final time and an initial datum
FinalTime = 0.15;
Y0 = 0.1*cos(0.5*pi*xline');

%%
% and construct the system
%%
% $$
% \begin{equation}\label{abstract_syst}
%   \begin{cases}
%       Y'(t) = AY(t)+BU(t), & t\in(0,T)
%       Y(0) = Y0.
%   \end{cases}
% \end{equation}
% $$
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',0.01);
dynamics.MassMatrix = M;
dynamics.mesh = xline;

%% Calculate the Target
Y0_other = cos(0.5*pi*xline');
dynamics.InitialCondition = Y0_other;
U00 = dynamics.Control.Numeric*0 + 0.5;
[~ ,YT] = solve(dynamics,'Control',U00);
YT = YT(end,:).';
%% Calculate Free 
dynamics.InitialCondition = Y0;
U00 = dynamics.Control.Numeric*0;
solve(dynamics,'Control',U00);

%% 
% Take simbolic vars
Y = dynamics.StateVector.Symbolic;
U = dynamics.Control.Symbolic;

%% Construction of the control problem norm-L1 

epsilon = dx^3;
%%
% $ \frac{1}{2 \epsilon} || Y - YT || ^2 + \int_0^T ||U||dt $
%%
Psi  = (dx/(2*epsilon))*(YT - Y).'*(YT - Y);
L    = (dx)*sum(abs(U));
%%
% Optional Parameters to go faster
Gradient                =  @(t,Y,P,U) dx*sign(U) + B*P;
Hessian                 =  @(t,Y,P,U) dx*eye(iCP.ode.Udim)*dirac(U);
AdjointFinalCondition   =  @(t,Y) (dx/(epsilon))* (Y-YT);
Adjoint = pde('A',A);
OCParmaters = {'Hessian',Hessian,'Gradient',Gradient,'AdjointFinalCondition',AdjointFinalCondition,'Adjoint',Adjoint};
%%
% build problem with constraints
iCP_norm_L1 =  OptimalControl(dynamics,Psi,L,OCParmaters{:});
iCP_norm_L1.constraints.Umax =  20*max(Y0_other);
iCP_norm_L1.constraints.Umin =  min(Y0_other);

%%
% Solver L1
Parameters = {'DescentAlgorithm',@ConjugateGradientDescent, ...
             'tol',1e-3,                                    ...
             'Graphs',false,                               ...
             'MaxIter',5000,                               ...
             'display','all',};
%%
GradientMethod(iCP_norm_L1,Parameters{:})
%%

%% Construction of the control problem norm-L2 
%%
% $ \frac{1}{2 \epsilon} || Y - YT || ^2 + \int_0^T ||U||^2dt $
Psi  = (dx/(2*epsilon))*(YT - Y).'*(YT - Y);
L    = (dx/2)*(U.'*U);
%%
% Optional Parameters to go faster
Gradient                =  @(t,Y,P,U) (dx*U + (B*P));
AdjointFinalCondition   =  @(t,Y) (dx/(epsilon))* (Y-YT);
Adjoint                 =  pde('A',A);
Hessian                 =  @(t,Y,P,U) dx*eye(iCP.ode.Udim);
%
OCParmaters = {'Hessian',Hessian,'Gradient',Gradient,'AdjointFinalCondition',AdjointFinalCondition,'Adjoint',Adjoint};
%%
iCP_norm_L2 = OptimalControl(dynamics,Psi,L,OCParmaters{:});
%iCP_norm_L2.constraints.Umax = 10*max(Y0_other);
%iCP_norm_L2.constraints.Umin = min(Y0_other);
%% Solver L2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Parameters = {'DescentAlgorithm',@ConjugateGradientDescent, ...
             'tol',1e-3,                                    ...
             'Graphs',false,                               ...
             'MaxIter',5000,                               ...
             'display','all',};
%
GradientMethod(iCP_norm_L2,Parameters{:})
%%
%%
figure
subplot(1,2,1)
surf(iCP_norm_L1.ode.Control.Numeric)
xlabel('Space')
ylabel('Time')

caxis([-0.2 0.2])
title('L1')
subplot(1,2,2)
surf(iCP_norm_L2.ode.Control.Numeric)
caxis([-0.2 0.2])
title('L2')
xlabel('Space')
ylabel('Time')
%%
solve(dynamics);
dynamics.label = 'Free';
iCP_norm_L2.ode.label = 'Control norm L^2';
iCP_norm_L1.ode.label = 'Control norm L^1';

%animation([iCP_norm_L2.ode,iCP_norm_L1.ode,dynamics],'YLim',[-1 1],'xx',0.05)

%%

%%
%  ```
% animation([iCP1.ode,dynamics],'YLim',[-1 1],'xx',0.05)
% ```
%%
% ![](extra-data/063235.gif)
%%
function [B] = construction_matrix_B(mesh,a,b)

N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);

end
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
