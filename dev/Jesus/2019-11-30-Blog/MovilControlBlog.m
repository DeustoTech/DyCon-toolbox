%% Movil Control
% En este tutorial se mostrará la estrategia del control movil para el
% control de una ecuación de calor 
%%
% $$ u_t = u_{xx} + f\chi_{\omega} $$

%%
error
clear;


Ns = 9;
Nt = 18;
xline = linspace(-1,1,Ns);
yline = linspace(-1,1,Ns);

[xms,yms] = meshgrid(xline,yline);

%% Bfunction
xwidth = 0.35;
ywidth = 0.35;
B = @(xms,yms,xs,ys) WinWP05(xms,xs,xwidth).*WinWP05(yms,ys,ywidth);
Bmatrix =  @(xs,ys) diag(reshape(B(xms,yms,xs,ys),1,Ns^2));
%%
A = FDLaplacial2D(xline,yline);

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
     + 2*gs(xms,yms,-0.25,-0.25,alpha);
 %
U0 = U0(:);

T = 0.3;
tspan = linspace(0,T,Nt+1);

%%
Ysym = sym('Y',[Ns^2+4 1]);
Usym = sym('U',[Ns^2+2 1]);
FDT = @(t,X,U,Params) Atotal*X+ [Bmatrix(X(end-3),X(end-2))*U(1:end-2) ;0; 0; U(end-1:end)];

idynammics = pde(FDT,Ysym,Usym);
idynammics.mesh = {xline,yline};
idynammics.InitialCondition = [U0;0;0;0;0];
idynammics.Nt = Nt+1;
idynammics.FinalTime = T;
idynammics.Solver = @eulere;
%
[~ , Xnum_free] = solve(idynammics);

Xnum_free = Xnum_free';
%%
figure;
isurf = surf(reshape(Xnum_free(1:Ns^2,end),Ns,Ns));
zlim([0 0.3])
for it = 1:Nt
    isurf.ZData = reshape(Xnum_free(1:Ns^2,it),Ns,Ns);
    pause(0.05)
end
%%
Fcas = @(x,u) Atotal*x+ [Bmatrix(x(end-3),x(end-2))*u(1:end-2) ;0;0; u(end-1:end)]; % dx/dt = f(x,u)


opti = casadi.Opti();  % CasADi function

% ---- Input variables ---------
Xcas = opti.variable(Ns^2+4,Nt+1); % state trajectory
Ucas = opti.variable(Ns^2+2,Nt+1);   % control

% ---- Dynamic constraints --------
for k=1:Nt % loop over control intervals
   % Euler forward method
   x_next = Xcas(:,k) + (T/Nt)*Fcas(Xcas(:,k),Ucas(:,k)); 
   opti.subject_to(Xcas(:,k+1)==x_next); % close the gaps
end

% ---- State constraints --------
opti.subject_to(Xcas(:,1)==[U0;0.5;0.5; 0 ;0]);

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
opti.set_initial(Xcas, Xnum_free);
opti.set_initial(Ucas, 0);


% ---- solve NLP              ------
p_opts = struct('expand',false);
s_opts = struct('acceptable_tol',5,'constr_viol_tol',1e-3,'compl_inf_tol',1e-3);
opti.solver('ipopt',p_opts,s_opts); % set numerical backend
tic
sol = opti.solve();   % actual solve
toc

%%
Xnum_with_control = sol.value(Xcas);
%% interpolation in time

AnimationMovilControl(Xnum_with_control,Xnum_free,tspan,xline,yline,Bmatrix)
%%
