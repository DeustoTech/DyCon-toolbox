clear;
%% Definimos la discretizacion del estado
Nxl = 100;
Nvl = 100;
Nal = 5;

xlmin = -6;  xlmax = 6;
xl = linspace(xlmin,xlmax,Nxl);
%
vlmin = -6;  vlmax = 6;
vl = linspace(vlmin,vlmax,Nvl);
%
almin = -5; almax = 5;
al = linspace(almin,almax,Nal);
%al = [0 almin almax];
%% discretizacion en tiempo
T = 10;
tspan = linspace(0,T,50);
dt = tspan(2) - tspan(1);
%% Definimos la forma del potencial
gs = @(x,x0,sigma) exp(-(x-x0).^2/sigma^2);
%
Vpot = @(x) 3*gs(x,0,1) - gs(x,0,4) - 10*gs(x,0,2) - 2*gs(x,-2,1) - 2*gs(x,2,1) ;

%%
% calculamos el menos gradiente del potencial mediante calculo simbolico
syms xsym 
Force_sym = -gradient(Vpot(xsym),xsym);
Force = matlabFunction(Force_sym,'Vars',xsym);
% Construimos la funcion de la dinamica
f_x = @(x,v,a)  v  ;
f_v = @(x,v,a)  Force(x)  - 0.5*v+ a  ;
          
%% Construimos el control óptimo LQR de este sistema
% linearizado en el punto de [0,0];c
f = @(s,a) [f_x(s(1),s(2),a) ; ...
            f_v(s(1),s(2),a) ];

%%
%[pi,V,Q] = QLearning(f,vl,xl,al,dt,100);
%[V,pi,Vhistory,Pihisotry] = QIteration(f_x,f_v,vl,xl,al,dt);
[V,pi,Vhistory,Pihisotry] = QIteration(f_x,f_v,vl,xl,al,dt);

%%
plotRF(f,Vpot,xl,vl,al,pi,V,Nxl,Nvl,dt)
