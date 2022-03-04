%%
clear all
import casadi.*
%
Ns = 5;
xline = linspace(-1,1,Ns);
yline = linspace(-1,1,Ns);
%%
us = SX.sym('u',Ns^2,1);
vs = SX.sym('v',Ns^2,1);
rs = SX.sym('r',Ns^2,1);
ts = SX.sym('t');
%%
lambda = 1.15;
kappa  = 0.0;
sigma  = 1.1; %%
%%
du = 6.25*1e-3;       dv = 100*du;
%
Au = FDLaplacian2D(xline,yline,'Diffusion',du);
Av = FDLaplacian2D(xline,yline,'Diffusion',dv);
%
xi = -0.5;xf = 0.5;
yi = -0.5;yf = 0.5;
Bu = BInterior2D(xline,yline,xi,xf,yi,yf);
%%
State = [us ;vs];
mu = 0.1;
%
A = [     Au           sparse(Ns^2,Ns^2)  ; ...
     sparse(Ns^2,Ns^2)       Av          ];
%
B = [ Bu   ;  sparse(Ns^2,Ns^2) ];
%
nlt =  [+us.*(us.*vs - mu)  ;  ...
                                       -vs.*us.^2 ]    ;

Nt =  20;
tspan = linspace(0,1,Nt);
%
ipde2d = semilinearpde2d(ts,State,rs,A,B,nlt,tspan,xline,yline);
%% Initial Condition
xms = ipde2d.xms;
yms = ipde2d.yms;

rng(100)

rms = sqrt(xms.^2+yms.^2);
thms = atan2(yms,xms);

expf = @(x,y) exp((-(xms-x).^2-(yms-y).^2)/0.04^2);
U0  = expf(0.0,0.0); 
U0  = U0 + 0.00075*rand(size(U0));

V0  = rms.^2 + 0.75 ;
%%
ipde2d.InitialCondition = [U0(:); V0(:)];
SetIntegrator(ipde2d,'OperatorSplitting')
%
%
rt_0 = ZerosControl(ipde2d);

State = solve(ipde2d,rt_0);

%%
rep = 10;
FullState = zeros(2*Ns^2,rep);
for irep = 1:rep
    FullState(:,irep) = full(ipde2d.InitialCondition);

    State = solve(ipde2d,rt_0);
    ipde2d.InitialCondition = State(:,end);
end
%%
subplot(1,2,1)
usurf = surf(reshape(full(FullState(1:Ns^2,1)),Ns,Ns));
zlim([0 3]);title('u')
subplot(1,2,2)
vsurf = surf(reshape(full(FullState(Ns^2+1:end,1)),Ns,Ns));
zlim([0 3]);title('v')

for irep = 1:rep
   usurf.ZData =  reshape(full(FullState(1:Ns^2,irep)),Ns,Ns);
   vsurf.ZData =  reshape(full(FullState(Ns^2+1:end,1)),Ns,Ns);
   pause(0.1)
end
