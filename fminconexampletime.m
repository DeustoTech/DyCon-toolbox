
clear
N = 20;
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
FinalTime = 0.3;
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

dt = 0.01;
FinalTime = 30*dt;
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
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
L    = sym(1)*dx; 
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
%%


U0 = iCP_norm_L1.ode.Control.Numeric(:)';
dt = 0.01;
State0 = [dt,U0];

ifunobj = @(State)funobj(iCP_norm_L1,State);

options = optimoptions(@fminunc,'display','iter');
fminunc(ifunobj,State0,options)


function Jfun = funobj(iCP,State)

    dt = abs(State(1));
    U0 = State(2:end); 
    U0 = reshape(U0,iCP.ode.Udim,length(iCP.ode.tspan)).';
    
    N = 30;
    iCP.ode.FinalTime = N*dt;
    iCP.ode.dt        = dt;
    
    Jfun = Control2Functional(iCP,U0);
    
end
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