import casadi.*
% Time Parameters 
clear
% Space Parameters 
N = 20;
xi = -1; xf = 1;
% mesh
xline = linspace(xi,xf,N);
yline = linspace(xi,xf,N);
%
[xms, yms] = meshgrid(xline,yline);
%% Dynamics Matrix 
k = 3;
thefcn  = @(r) 0.5 + 0.5*tanh(k*r);
winfcn  = @(r,sz) 1 - thefcn(r-0.5*sz) - thefcn(-r-0.5*sz);
%
szx = 0.1;szy = 0.1;
%
win2d = @(x,y) winfcn(yms-y,szy).*winfcn(xms-x,szx);

A = 0.35*FDLaplacian2D(xline,yline);
B = @(x,y) reshape(win2d(x,y),N*N,1);
%%
Us = SX.sym('U',[N*N 1]);
Vs = SX.sym('V',[N*N 1]);

rs = SX.sym('r',[2 1]);
vs = SX.sym('v',[2 1]);
as = SX.sym('a',[2 1]);

ts = SX.sym('t');


%F  = @(t,Y,U,Params) A*Y + BFcn(Y(end-1),Y(end))*U;
State = [Us;rs;vs];
Control = [Vs;as];
%
Fs = Function('f',{ts,State,Control},{ [A*Us + 4*Us + B(rs(1),rs(2)).*Vs ; 
                                                 vs;
                                                 1e1*as - 1e4*rs  - vs]});


%%
T = 0.25;
Nt = 50;
tspan = linspace(0,T,Nt);
dynamics = pde2d(Fs,[Us;rs;vs],[Vs;as],tspan,xline,yline);
SetIntegrator(dynamics,'RK8')
%%
alpha = 0.05;
W0 = exp(-((xms-0.5).^2 + yms.^2)/alpha.^2) + ...
     exp(-((xms+0.5).^2 + yms.^2)/alpha.^2) + ...
     exp(-(xms.^2 + (yms-0.5).^2)/alpha.^2) + ...
     exp(-(xms.^2 + (yms+0.5).^2)/alpha.^2) - ...
     2*exp(-(xms.^2 + yms.^2)/(0.75*alpha).^2);
W0 = 10*W0(:)';
% Add two additional variables - position of obj
r0 = [0.75 0.5];
v0 = [0.0 5];
%
W0 = [W0 r0 v0]';
%
dynamics.InitialCondition = W0;
%
Control0 = -5e1+ZerosControl(dynamics);
Control0(end-1,:) = 0;
Control0(end,:)   = 0;

Yfree = solve(dynamics,Control0);
%%
%fig = figure(3);
%clf
%animation2DMovil(fig,dynamics,full(Yfree)')
%%
YT = 0*W0;
PathCost  = casadi.Function('L'  ,{ts,State,Control},{ Control'*Control  });
FinalCost = casadi.Function('Psi',{State}           ,{ 1e8*(Us'*Us)   });

iocp = ocp(dynamics,PathCost,FinalCost);
%%
ControlGuess =  ZerosControl(dynamics) - 100;
ControlGuess(end  ,:) = +10; 
ControlGuess(end-1,:) =  0; 

[ControlOpt,Yopt] = ArmijoGradient(iocp,ControlGuess,'MaxIter',100,'MinLengthStep',1e-10);
%%
figure(1);
clf
subplot(2,1,1)
plot(Yopt(end-1,:),Yopt(end,:))
subplot(2,1,2)
plot(Yopt(end-3,:),Yopt(end-2,:))

%%
fig = figure(3); 
clf
animation2DMovil(fig,dynamics,Yopt')
%%

