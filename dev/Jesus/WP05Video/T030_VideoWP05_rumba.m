clear;

memory = 1;

Ns = 15;
Nt = 30;
xline = linspace(-1,1,Ns);
yline = linspace(-1,1,Ns);

A = FDLaplacial2D(xline,yline);
[xms,yms] = meshgrid(xline,yline);

%% Bfunction
xwidth = 0.25;
ywidth = 0.25;
B = @(xms,yms,xs,ys) WinWP05(xms,xs,xwidth).*WinWP05(yms,ys,ywidth);

Bmatrix =  @(xs,ys) diag(reshape(B(xms,yms,xs,ys),1,Ns^2));
%%
Atotal = zeros(Ns^2+4,Ns^2+4);
Atotal(1:Ns^2,1:Ns^2) = A;

RumbaMatrixDynamics = [0 0 1 0; ...
                       0 0 0 1; ...
                       0 0 0 0; ...
                       0 0 0 0 ];

Atotal(Ns^2+1:end,Ns^2+1:end) = RumbaMatrixDynamics;

%%

alpha = 0.1;
alphamid = 0.2;
gs = @(x,y,x0,y0,alpha) exp(-(x-x0).^2/alpha^2  - (y-y0).^2/alpha^2);
U0 = + 2*gs(xms,yms,+0.25,+0.25,alpha) ...
     + 2*gs(xms,yms,+0.25,-0.25,alpha) ...
     + 2*gs(xms,yms,-0.25,-0.25,alpha) ...
     + 0*gs(xms,yms,-0.25,+0.25,alpha) ...
     + 0.0*gs(xms,yms,0,0,alphamid) ;
 %
%U0 = + 5*gs(xms,yms,+0.65,+0.65,alpha);
W0 = U0(:);

T = 0.01;
tspan = linspace(0,T,Nt+1);

%%
Ysym = sym('Y',[Ns^2+4 1]);
Usym = sym('U',[Ns^2+2 1]);
F = @(t,X,U,Params) Atotal*X+ [Bmatrix(X(end-3),X(end-2))*U(1:end-2) ;0; 0; U(end-1:end)];

idynammics = pde(F,Ysym,Usym);
idynammics.mesh = {xline,yline};
idynammics.InitialCondition = [W0;0;0;0;0];
idynammics.Nt = Nt+1;
idynammics.FinalTime = T;
idynammics.Solver = @eulere;

Control = -20*ones(Nt+1,Ns^2+2);
Control(:,end-1:end) = [ 0.1*(sin(pi*tspan'/T)) 0.1*cos(pi*tspan'/T)];
[~ , Xnum_free] = solve(idynammics,'Control',0*Control);

Xnum_free = Xnum_free';

%%
f = @(x,u) Atotal*x+ [Bmatrix(x(end-3),x(end-2))*u(1:end-2) ;0;0; u(end-1:end)]; % dx/dt = f(x,u)


opti = casadi.Opti();  % CasADi function

% ---- Input variables ---------
Xcas = opti.variable(Ns^2+4,Nt+1); % state trajectory
Ucas = opti.variable(Ns^2+2,Nt+1);   % control

% ---- Dynamic constraints --------
for k=1:Nt % loop over control intervals
   % Euler forward method
   x_next = Xcas(:,k) + (T/Nt)*f(Xcas(:,k),Ucas(:,k)); 
   opti.subject_to(Xcas(:,k+1)==x_next); % close the gaps
end

% ---- State constraints --------
opti.subject_to(Xcas(:,1)==[W0;0.5;0.5; 0 ;0]);

HeatCas = Ucas(1:end-2,:);
Max = 1e4;
opti.subject_to(HeatCas(:) <= Max)
opti.subject_to(HeatCas(:) >= -Max)

% ---- Optimization objective  ----------
beta = 1e-2;
%Cost = (Xcas(1:end-4,Nt+1))'*(Xcas(1:end-4,Nt+1)) + beta*sum(sum((Ucas(1:end-2,:))'*(Ucas(1:end-2,:))));
Cost = (Xcas(1:end-4,Nt+1))'*(Xcas(1:end-4,Nt+1));

opti.minimize(Cost); % minimizing L2 at the final time

% ---- initial guesses for solver ---
opti.set_initial(Xcas, repmat([W0; 0;0;5;5],[1 Nt+1]));
opti.set_initial(Ucas, -1);


% ---- solve NLP              ------
p_opts = struct('expand',false);
s_opts = struct('acceptable_tol',1e-1,'constr_viol_tol',1e-3,'compl_inf_tol',1e-3);
opti.solver('ipopt',p_opts,s_opts); % set numerical backend
tic
sol = opti.solve();   % actual solve
toc

%%
Xnum_with_control = sol.value(Xcas);
%Unum = sol.value(Xcas);
%% interpolation in time

tspan_fine = linspace(tspan(1),tspan(end),4*length(tspan));

Xnum_with_control    = interp1(tspan,Xnum_with_control(:,1:end)',tspan_fine)';
Xnum_free            = interp1(tspan,Xnum_free',tspan_fine)';
%%
xline_fine = linspace(xline(1),xline(end),8*length(xline));
yline_fine = linspace(yline(1),yline(end),8*length(yline));
[xms_fine,yms_fine] = meshgrid(xline_fine,yline_fine);
%%
ReLoadData = false;
if ReLoadData
    load('WP05Rumba.mat')
end
%%
figure('unit','norm','pos',[0 0 1 1]);
ax1 = subplot(1,3,1);
Z = reshape(Xnum_with_control(1:end-4,1),Ns,Ns);
isurf = surf(xms_fine,yms_fine,interp2(xms,yms,Z,xms_fine,yms_fine,'spline'),'Parent',ax1);
ax2 = subplot(1,3,2);
Z = reshape(Xnum_free(1:end-4,1),Ns,Ns);
jsurf = surf(xms_fine,yms_fine,interp2(xms,yms,Z,xms_fine,yms_fine,'spline'),'Parent',ax2);
ax3 = subplot(1,3,3);
Z = reshape(diag(Bmatrix(Xnum_with_control(1,end)',Xnum_with_control(1,end-1)')),Ns,Ns);
ksurf =surf(xms_fine,yms_fine,interp2(xms,yms,Z,xms_fine,yms_fine),'Parent',ax3);

zlim(ax1,[-1 2])
zlim(ax2,[-1 2])
zlim(ax3,[-0.1 1])
%
view(ax1,-5,10)
view(ax2,-5,10)
view(ax3,-0,90)
%
caxis(ax1,[-0.1 0.1])
caxis(ax2,[-0.1 0.1])
caxis(ax3,[ 0 0.5])
%
shading(ax1,'interp')
shading(ax2,'interp')
%
lighting(ax1,'gouraud')
lighting(ax2,'gouraud')

%
lightangle(ax1,40,40)
lightangle(ax2,40,40)

title(ax1,'Control Dynamics')
title(ax2,'Free Dynamics')
title(ax3,'Sub-domain - \omega')

%%

for it = 1:length(tspan_fine)
    % controled state
    Z = reshape(Xnum_with_control(1:end-4,it),Ns,Ns);
    isurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'spline');
    %
    Z = reshape(Xnum_free(1:end-4,it),Ns,Ns);
    jsurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'spline');
    %
    Z = reshape(diag(Bmatrix(Xnum_with_control(end-3,it)',Xnum_with_control(end-2,it)')),Ns,Ns);
    ksurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'linear');
    pause(0.05)
end

%%
figure

plot(Xnum_with_control(end-2,:)',Xnum_with_control(end-3,:)','.-')
xlim([-1 1]);
ylim([-1 1])