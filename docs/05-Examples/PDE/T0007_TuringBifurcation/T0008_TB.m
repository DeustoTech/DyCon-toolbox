clear;

Ns = 10;

xline = linspace(-1,1,Ns+2);
yline = linspace(-1,1,Ns+2);
%
xline = xline(2:end-1);
yline = yline(2:end-1);

%

import casadi.*
%
Us = SX.sym('u',Ns*Ns,1);
Ms = SX.sym('m',Ns*Ns,1);
ts = SX.sym('t');

%%
lambda = 1.15;
kappa  = 0.0;
sigma  = 1.1; %%
%%
mu = 0.001; 
%
A = FDLaplacian2D(xline,yline);
B = sparse(Ns*Ns,Ns*Ns);
%%
NLT =  Us.*(Ms - Us) ;
%%
%
Nt = 10;
tspan = linspace(0,1,Nt);
%
idyn = semilinearpde2d(ts,Us,Ms,A,B,NLT,tspan,xline,yline);

SetIntegrator(idyn,'OperatorSplitting')
%% Initial Condition
[xms,yms] = meshgrid(xline,yline);
U0 = exp(-xms.^2-yms.^2);
idyn.InitialCondition = [U0(:)];
%%
Wt = solve(idyn,1+ZerosControl(idyn));
%%
%
figure(1)
clf
%
isurf = surf(xms,yms,full(reshape(Wt(:,1),Ns,Ns)));
title('U')
colorbar
zlim([0 1])
caxis([-1 1])

for it = 1:Nt
    isurf.ZData = full(reshape(Wt(:,it),Ns,Ns));
    pause(0.1)
end

%

