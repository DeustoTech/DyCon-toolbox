%%
clear 
%% DEFINIMOS MALLA

Ns =  20;
Nt =  100;
xline = linspace(-1,1,Ns+2);
yline = linspace(-1,1,Ns+2);
xline = xline(2:end-1);
yline = yline(2:end-1);

%% Matrices FD
A = FDLaplacian2D(xline,yline);
B1 = BInterior2D(xline,yline , -1.0 , +1.0 , -1.0, -0.5); 
B2 = BInterior2D(xline,yline , -1.0 , +1.0 , +0.5, +1.0); 
B3 = BInterior2D(xline,yline , -1.0 , -0.5 , -1.0, +1.0); 
B4 = BInterior2D(xline,yline , +0.5 , +1.0 , -1.0, +1.0); 

B = (B1 + B2 + B3 + B4 )/4 ;
B = sparse(double(B~=0));
%% MALLADO EN EL TIEMPO
tspan = linspace(0,0.2,Nt);
%%
import casadi.*

Us = SX.sym('u',Ns*Ns,1);
Vs = SX.sym('v',Ns*Ns,1);
ts = SX.sym('t');

%% Defines dinamica
Fs =  A*Us + B*Vs + sin(pi*Us);
%% CREAS OBJETO
idyn = pde2d(Fs,ts,Us,Vs,tspan,xline,yline);
SetIntegrator(idyn,'RK4')
%% ESTOS SON LOS MESHGRID PARA CREAR LA CONDICION INICIAL
xms = idyn.xms;
yms = idyn.yms;
U0  = 2*exp((-xms.^2 - yms.^2)/0.25^2);
idyn.InitialCondition = U0(:);
%%
dx = xline(2) - xline(1);
dy = yline(2) - yline(1);

eps = 0.5*dx^4 + 0.5*dy^4;

UT = U0(:)*0; %% TARGET ZERO
UT = 0.25*U0(:);   %% TARGET CONDICION INICIAL

PathCost  =  Vs.'*Vs  ;
FinalCost =  (1/(2*eps))*((Us-UT).'*(Us-UT)) ;

iocp = ocp(idyn,PathCost,FinalCost);
iocp.TargetState = UT;

%% RESOLVEMOS CONTROL OPTIMO
V0 = ZerosControl(idyn)+1;
[Vt ,Ut]  = ArmijoGradient(iocp,V0,'MaxIter',100,'MinLengthStep',1e-19);

Vt = full(Vt);
Ut = full(Ut);

%[Vt ,Ut]  = IpoptSolver(iocp,V0);

%% CALCULAMOS FREE SOLUTION
UtFree = full(solve(idyn,ZerosControl(idyn)));
UtFree = full(UtFree);
%% ANIMACION
clf
subplot(2,2,1)
isurf = surf(xms,yms,reshape(Ut(:,1),Ns,Ns));
colormap jet
zlim([-0.25 1.75])
caxis([-0.0 0.5])
title('Dynamics with control')
shading interp
view(-25,50)
%
subplot(2,2,2)
jsurf = surf(xms,yms,reshape(Vt(:,1),Ns,Ns));
colormap jet
zlim([-50 50])
caxis([-2 5])
title('Control')
shading interp
view(-25,50)

%
subplot(2,2,3)
ksurf = surf(xms,yms,reshape(UtFree(:,1),Ns,Ns));
colormap jet
zlim([-0.25 1.75])
caxis([-0.0 0.5])
title('Free Dynamics')
shading interp
view(-25,50)

%
subplot(2,2,4)
surf(xms,yms,reshape(UT(:,1),Ns,Ns));
colormap jet
zlim([-0.25 1.75])
caxis([-0.0 0.5])
title('Target')
view(-25,50)
shading interp

%%% ANIMACION
for it = 2:2:Nt
   isurf.ZData = reshape(Ut(:,it),Ns,Ns);
   jsurf.ZData = reshape(Vt(:,it),Ns,Ns);
   ksurf.ZData = reshape(UtFree(:,it),Ns,Ns);
   pause(0.15);
end