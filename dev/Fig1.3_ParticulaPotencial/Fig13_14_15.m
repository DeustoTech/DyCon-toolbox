 close all
clear;
%% Definimos la discretizacion del estado
Nxl = 120;
Nvl = 120;
Nal = 3;
% espacio
xlmin = -6;  xlmax = 6;
xl = linspace(xlmin,xlmax,Nxl);
% velocidad
vlmin = -6;  vlmax = 6;
vl = linspace(vlmin,vlmax,Nvl);
% accion
almin = -20; almax = 20;
al = linspace(almin,almax,Nal);
al = [0 almin almax];
%% discretizacion en tiempo
T = 5;
tspan = linspace(0,T,70);
dt = tspan(2) - tspan(1);
%% Definimos la forma del potencial
gs = @(x,x0,sigma) exp(-(x-x0).^2/sigma^2);
%
Vpot = @(x) 3*gs(x,0,1) - gs(x,0,4) - 10*gs(x,0,2) - 2*gs(x,-2,1) - 2*gs(x,2,1) ;
%% Dibujamos el potencial
close all
fig = figure(1);
xline = linspace(-5,5,100);

[minVpot,indVpot] = min(Vpot(xline));
xminVpot = xline(indVpot);
%
plot(xline,Vpot(xline),'LineWidth',2,'Color',[0.4 0.4 0.4])
hold on
plot([- xminVpot xminVpot],[minVpot minVpot] ,'Marker','.','MarkerSize',30,'LineStyle','none','color','r')

plot([ 0 ],[Vpot(0)] ,'Marker','.','MarkerSize',30,'LineStyle','none','color','b')

%
xlabel('x')
ylabel('P(x)')
grid on
print('../../Tesis/img/Potential.eps',fig,'-depsc')

%% calculamos el menos gradiente del potencial mediante calculo simbolico
syms xsym 
Force_sym = -gradient(Vpot(xsym),xsym);
Force = matlabFunction(Force_sym,'Vars',xsym);
% Construimos la funcion de la dinamica
f_x = @(x,v,a)  v  ;
f_v = @(x,v,a)  Force(x)  - 0.5*v+ a  ;
          
%% Construimos el control óptimo LQR de este sistema
% linearizado en el punto de [0,0];
f = @(s,a) [f_x(s(1),s(2),a) ; ...
            f_v(s(1),s(2),a) ];
syms vsym xsym asym

Asym = jacobian(f([xsym,vsym].',asym),[xsym,vsym]);
Bsym = jacobian(f([xsym,vsym].',asym),asym);


A = double(subs(Asym,{xsym,vsym},{0,0}));
B = double(Bsym);
% Obtenemos la ganancia
K= lqr(A,B,eye(2),1);
% Este nos da la politica optima de forma que a(s) = - K*s
%
%% Dibujamos el espacio de Fases del sistemas libre
fig = figure;
xl_less = linspace(xlmin,xlmax,floor(Nxl/5));
vl_less = linspace(vlmin,vlmax,floor(Nvl/5));
phasep(@(s) f(s,0),T,dt,xl_less,vl_less)
grid on
FS = 12;
options = {'Interpreter','tex','FontSize',FS};
% title('Espacio de fases del sistema libre',options{:})
xlabel('x',options{:})
ylabel('v',options{:})
print('../../Tesis/img/freepot.eps',fig,'-depsc')
%
hold on 
plot([-xminVpot xminVpot],[0 0] ,'Marker','.','MarkerSize',30,'LineStyle','none','color','r')
plot([ 0 ],[0] ,'Marker','.','MarkerSize',30,'LineStyle','none','color','b')

print('../../Tesis/img/pp_free.eps',fig,'-depsc')


%%
[V,pi,Vh,pih] = QIteration(f_x,f_v,vl,xl,al,dt);
% V  -> funcion valor
% pi -> politica
%
%
%%

s0 = [-2 4]';
[~,st_feedback] = rk4(@(t,s) f(s,evaluatePolicy(s,xl,vl,al,pi)),tspan,s0);
[~,st_free]     = rk4(@(t,s) f(s,0),tspan,s0);
%%
at = arrayfun(@(it)  evaluatePolicy(st_feedback(it,:),xl,vl,al,pi),1:length(tspan),'UniformOutput',true);
%% utilizamos un mallado del espacio ms grueso para dibujar el espacio de fases
xl_less = linspace(xlmin,xlmax,floor(Nxl/5));
vl_less = linspace(vlmin,vlmax,floor(Nvl/5));

fig = figure;
% title('Política obtenida',options{:})
xlabel('x',options{:})
ylabel('v',options{:})

[~,st_feedback] = rk4(@(t,s) f(s,evaluatePolicy(s,xl,vl,al,pi)),tspan,s0);
phasep(@(s) f(s,evaluatePolicy(s,xl,vl,al,pi)),T,dt,xl_less,vl_less)
%
hold on 
plot(st_feedback(1,1),st_feedback(1,2),'LineWidth',3,'Marker','o','MarkerSize',10,'color','k')
plot(st_feedback(:,1),st_feedback(:,2),'LineWidth',3,'color','k')
plot(st_feedback(end,1),st_feedback(end,2),'LineWidth',3,'Marker','d','MarkerSize',10,'color','k')

print('../../Tesis/img/solpot.eps',fig,'-depsc')
%%
Nt = 200;
pi = QLearning(Vpot,f,vl,xl,al,dt,Nt);

fig = figure;
% title('Política obtenida',options{:})
xlabel('x',options{:})
ylabel('v',options{:})

[~,st_feedback] = rk4(@(t,s) f(s,evaluatePolicy(s,xl,vl,al,pi)),tspan,s0);
phasep(@(s) f(s,evaluatePolicy(s,xl,vl,al,pi)),T,dt,xl_less,vl_less)
%
hold on 
plot(st_feedback(1,1),st_feedback(1,2),'LineWidth',3,'Marker','o','MarkerSize',10,'color','k')
plot(st_feedback(:,1),st_feedback(:,2),'LineWidth',3,'color','k')
plot(st_feedback(end,1),st_feedback(end,2),'LineWidth',3,'Marker','d','MarkerSize',10,'color','k')

print('../../Tesis/img/phase_Qlearning.eps',fig,'-depsc')


%%
fig = figure;
% title('Regulador lineal cuadrático',options{:})
xlabel('x',options{:})
ylabel('v',options{:})
[~,st_feedback] = rk4(@(t,s) f(s,-K*s),tspan,s0);
phasep(@(s) f(s,-K*s),T,dt,xl_less,vl_less)
print('../../Tesis/img/lqrpot.eps',fig,'-depsc')

%%
[xms,vms] = meshgrid(xl,vl);
close all

fig = figure('unit','norm','pos',[0.1 0.1 0.6 0.6]);

ii = 0;
options = {'Interpreter','tex','FontSize',3};

for i=1:2:12
    ii = ii +1;
    subplot(2,3,ii)
    surf(xms,vms,Vh(:,:,i))
    xlabel('x',options{:})
    ylabel('v',options{:})
    shading interp
    colormap jet
    view(0,90)
    title("iter = "+(i-1),'FontSize',9)
    caxis([-0.0 0.15])
    yticks([-6 0 6])
    xticks([-6 0 6])
end


hp4 = get(subplot(2,3,6),'Position');
colorbar('Position', [hp4(1)+hp4(3)+0.0325  hp4(2)  0.0125  hp4(2)+hp4(3)*3.25])


print('../../Tesis/img/valueiteration.eps',fig,'-depsc')

%%
[xms,vms] = meshgrid(xl,vl);
close all

fig = figure('unit','norm','pos',[0.1 0.1 0.6 0.6]);

ii = 0;
options = {'Interpreter','tex','FontSize',8};

for i=1:2:12
    ii = ii +1;
subplot(2,3,ii)
    surf(xms,vms,al(pih(:,:,i)))
xlabel('x',options{:})
ylabel('v',options{:})
shading interp
colormap jet
view(0,90)
title("iter = "+(i-1),'FontSize',9)
caxis([al(1) al(end)])
yticks([-6 0 6])
xticks([-6 0 6])
end

hp4 = get(subplot(2,3,6),'Position');
colorbar('Position', [hp4(1)+hp4(3)+0.0325  hp4(2)  0.0125  hp4(2)+hp4(3)*3.25])



print('../../Tesis/img/valueiterationpi.eps',fig,'-depsc')

%%



