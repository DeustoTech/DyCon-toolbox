%% 
% We use DyCon Toolbox for solving numerically the following control 
% problem: given any $T>0$, find a control function $g\in L^2((−1,1)\times (0,T))$ 
% such that the corresponding solution to the parabolic problem
%%
% \begin{equation*}
%   \begin{cases}
%       z_t+(d_x^2)^s z = g\chi_\omega, & (x,t)\in(-1,1)\times(0,T)
%       z = 0, & (x,t)\in[\mathbb{R}\setminus(-1,1)]\times(0,T)
%       z(x,0) = z_0(x), & x\in(-1,1)
%   \end{cases}
% \end{equation*}
% satisfies $z(x,T)=0$.
%%
% Here, for all $s\in(0,1)$, $(-d_x^2)^s$ denotes the one-dimensional 
% fractional Laplace operator, defined as the following singular integral
%%
% \begin{equation*}
%   (-d_x^2)^s z(x) = c_s P.V. \int_{\mathbb{R}}
%   \frac{z(x)-z(y)}{|x-y|^{1+2s}}\,dy.
% \end{equation*}
%% 
% Let us consider a uniform partition of the space interval $(-1,1)$.

%% Parametros de discretizacion
N = 20;
xi = -1; xf = 1;
xline = linspace(xi,xf,N);

%% Creamos el ODE 

s = 0.8;
A = -10*FEFractionalLaplacian(s,1,N);
%%%%%%%%%%%%%%%%  
a = -0.3; b = 0.5;
B = construction_matrix_B(xline,a,b);
%%%%%%%%%%%%%%%%
FinalTime = 0.5;
Y0 =sin(pi*xline)';

dynamics = ode('A',A,'B',B,'Condition',Y0,'FinalTime',FinalTime,'dt',0.01);
dynamics.RKMethod=  @ode23tb;
%% Creamos Problema de Control
Y = dynamics.VectorState.Symbolic;
U = dynamics.Control.Symbolic;

YT = 0.0*xline';

dx = xline(2) -xline(1);

symPsi  = dx*(YT - Y).'*(YT - Y);
symL    = dx*0.001*(U.'*U);
iCP1 = OptimalControl(dynamics,symPsi,symL);

%% Solve Gradient
tol = 0.00001;
%%
GradientMethod(iCP1,'DescentAlgorithm',@AdaptativeDescent,'tol',tol)
plot(iCP1,'TypeGraphs','PDE')

% iCP1.ode.label = 'Control';
% dynamics.label = 'Dynamics';
% animation([iCP1.ode,dynamics],'YLim',[-1 1],'xx',0.05)

function [B] = construction_matrix_B(mesh,a,b)

N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);

end
