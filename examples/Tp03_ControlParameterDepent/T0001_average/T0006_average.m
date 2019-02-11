%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% System matrices A, B
% zdiff = A*z + B*u
% dz/dt = A*z + B*u
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Length of vector nu (number of parameters)
% Vector of parameters
nu = 1:2:6;
% Size of state vector
N = 3;
M = length(nu);

Am = eye(N, N);
for i = 1:N
    for j = 1:N
        if j > i
            Am(i, j) = 1;
        end
    end
end
Am = -Am;

Bm = zeros(N, 1);
Bm(N) = 1;

A = zeros(M*N, M*N);
B = zeros(M*N, 1);
for j = 1:M
    Ainit = N*(j-1)+1;
    Aend  = N*j;
    
    A(Ainit:Aend,Ainit:Aend) = Am + (nu(j) - 1 )*diag(diag(Am));    
    B(Ainit:Aend, :) = Bm;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial condition
z0 = ones(N, 1);


iode = ode('A',A,'B',B);
iode.Condition = repmat(z0,M,1);
iode.dt = 0.01;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solve(iode)
plot(iode)

%% 
ys = iode.VectorState.Symbolic;
u  = iode.Control.Symbolic;
%%
ysm = arrayfun(@(index) mean(ys(index:M:N*M)),1:M).';
yt = 0*ones(N, 1); 
Psi = (ysm - yt).'*(ysm - yt);
beta = 1e-3;
L   = 0.5*beta*u.'*u;

iCP1 = OptimalControl(iode,Psi,L);
%% 
% Solve 
GradientMethod(iCP1)
%%
% Solution 
plot(iCP1.ode)

%%
% See average free
cellstate = arrayfun(@(index) mean(iode.VectorState.Numeric(:,index:M:N*M),2),1:M,'UniformOutput',0);
meanvector = [cellstate{:}];
plot(meanvector);
%%
% Average Control
cellstate = arrayfun(@(index) mean(iCP1.ode.VectorState.Numeric(:,index:M:N*M),2),1:M,'UniformOutput',0);
meanvector = [cellstate{:}];
plot(meanvector);