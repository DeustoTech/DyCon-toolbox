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
% a = -0.3; b = 0.5;
% B = BInterior(xline,a,b);

a = -0.3; b = 0.5;
newcontrol = (xline>=a).*(xline<=b);
control = newcontrol;
control(control == 0) = [];
Nu = length(control);

B =  BInterior(xline,-0.3,0.8);
%p.Nu = p.Nx;
B =  B(:,newcontrol == 1);
    
%%
% We can then define a final time and an initial datum
FinalTime = 0.5;
Y0 =0.5*cos(0.5*pi*xline');
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
iode.Nt = 100;

iode.FinalTime = FinalTime;

iode.InitialCondition = Y0;
%% Target 
iodeCopy = copy(iode);
iodeCopy.InitialCondition = 6*cos(0.5*pi*xline');
U0 = zeros(iodeCopy.Nt,iodeCopy.Udim) + 1;
[~ , ytarget ] = solve(iodeCopy,'Control',U0);
ytarget = ytarget(end,:)';
%%
Y = iode.StateVector.Symbolic;
U = iode.Control.Symbolic;

symPsi  = dx*((Y - ytarget).'*(Y - ytarget));
symL    = dx^5*sum(abs(U));
%symL    = dx*1/2*(U.'*U);

iCP = Pontryagin(iode,symPsi,symL);
%%
U0 = 0*ones(length(iCP.Dynamics.tspan),iCP.Dynamics.Udim);
%U0 = P0*B;

%load('U0normL1.mat')

%U0 = U0_normL1_struct.U0;

%%
%funobj =  @(U_T) Control2Functional(iCP,reshape(U_T(1:end-1),iode.Nt,iode.Udim),U_T(end));
funobj =  @(U) Control2Functional(iCP,U);

options = optimoptions('fmincon','SpecifyObjectiveGradient' , true   , ...
                                            'Algorithm','sqp',...
                                           'CheckGradients' , false   , ...
                                                  'Display' , 'iter' , ...
                                            'MaxIterations' , 1e3);

%U0 = U0(:);
%U0(end+1) = 0.5;
U0_normL1_struct.U0  = fmincon(funobj,U0, ...
                                    [],[], ...
                                    [],[], ...
                                    U0*0,[], ...
                                    [], ...
                                options);

%%
%iode.FinalTime = U0_normL1_struct.U0(end);
%U00 = reshape(U0_normL1_struct.U0(1:end-1),iode.Nt,iode.Udim)
U0_normL1_struct.U0 = iCP.Dynamics.Control.Numeric;
iode.FinalTime
U00 = U0_normL1_struct.U0;
[~ , Ysol] = solve(iode,'Control',U00);

%%
figure
subplot(2,2,1)
surf(U00)
subplot(2,2,2)
surf(Ysol)
subplot(2,2,3)
plot(Ysol(end,:))
hold on
plot(Ysol(1,:))
plot(ytarget,'*--')

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

