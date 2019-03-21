clear

%% Parametros de discretizacion
N = 50;
xi = -1; xf = 1;
xline = linspace(xi,xf,N+2);
xline = xline(2:(end-1));
dx = xline(2)-xline(1);

epsilon = dx^4;

s = 0.8;
A = FEFractionalLaplacian(s,1,N);

M = massmatrix(xline);
%%
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "construction_matrix_B" (see below).
a = -0.3; b = 0.5;
B = construction_matrix_B(xline,a,b);
%%
% We can then define a final time and an initial datum
FinalTime = 0.5;
Y0 =sin(pi*xline)';
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
C =  -A;
B =  B;
%%%%%%%%%%%%%%%%
iode = pde('A',C,'B',B);
iode.MassMatrix = M;
iode.mesh = xline;
iode.dt = 0.01;

iode.FinalTime = FinalTime;

iode.InitialCondition = Y0;
%%
Y = iode.StateVector.Symbolic;
U = iode.Control.Symbolic;

symPsi  = dx*1/(2*epsilon)*(Y).'*(Y);
symL    = dx*sum(abs(U));
%symL    = dx*1/2*(U.'*U);

iCP = OptimalControl(iode,symPsi,symL);

P0 = 0.0005*ones(length(iCP.ode.tspan),iCP.ode.Udim);
U0 = P0*B;

load('U0normL1.mat')

U0 = U0_normL1_struct.U0;

funobj =  @(U) Control2Functional(iCP,U);

options = optimoptions('fminunc','Algorithm','quasi-newton','SpecifyObjectiveGradient',false,'Display','iter');

U0_normL1_struct.U0  = fminunc(funobj,U0,options);

U0_normL1_struct.tspan = iCP.ode.tspan;


surf(U0_normL1_struct.U0)
figure 
solve(iode)
plot(iode.StateVector.Numeric(end,:))
hold on
plot(iCP.ode.StateVector.Numeric(end,:))
figure
surf(iCP.ode.StateVector.Numeric)
% colorbar
% caxis([-5 5])
% title('Optimal Control')
% ylabel('time')
% xlabel('space')
% zlim([-20 20])
% view(0,90)
% shading interp
% 
% save('U0normL1')


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

