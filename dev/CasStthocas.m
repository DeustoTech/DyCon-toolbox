clear 
import casadi.*

Nt = 100;
tspan = linspace(0,1,Nt);
%% Sym Vars
Nu = 1;
N  = 2;
xs = SX.sym('x',N,1);
ps = SX.sym('p',N,1);
us = SX.sym('u',Nu,1);
ts = SX.sym('t');
nu = SX.sym('nu');
%% Dynamics
A = @(nu) [ -nu    2;
             1   -nu];
%
B = [0 ;
     1];

%
F = Function('F',{ts,xs,us,nu},{ A(nu)*xs + B*us });

%% Create Integrator
x0_sym = casadi.SX.sym('x0',N,1); 
xt_sym = casadi.SX.sym('xt',N,Nt);
%
ut_sym = casadi.SX.sym('ut',Nu,Nt);
%
%%
%
xt_sym(:,1) = x0_sym;
for it = 2:Nt
   dt = tspan(2) - tspan(1);
   xt_sym(:,it) = xt_sym(:,it-1) + dt*(F(tspan(it-1),xt_sym(:,it-1),ut_sym(:,it-1),nu) );

end
Integrator = casadi.Function('Ft',{x0_sym,ut_sym,nu},{xt_sym});

%%
L    = Function('L'  ,{ts,xs,us,nu},{ (us.'*us) });
Psi  = Function('Psi',{xs,nu}      ,{  1e6*(xs.'*xs) });
%
Psix = Function('Psix',{xs,nu} ,{ jacobian(Psi(xs,nu),xs) });
%
H    = Function('H' ,{ts,xs,us,ps,nu},{ L(ts,xs,us,nu) + ps'*F(ts,xs,us,nu) });
%
Hx   = Function('Hx',{ts,xs,us,ps,nu},{ jacobian(H(ts,xs,us,ps,nu),xs)  });
Hu   = Function('Hu',{ts,xs,us,ps,nu},{ jacobian(H(ts,xs,us,ps,nu),us)  });
%
%% Create Integrator
x0_sym = casadi.SX.sym('x0',N,1); 
xt_sym = casadi.SX.sym('xt',N,Nt);
%
ut_sym = casadi.SX.sym('ut',Nu,Nt);
%
p0_sym = casadi.SX.sym('p0',N,1); 
pt_sym = casadi.SX.sym('pt',N,Nt);

F_adj = Function('Fadj',{ts,xs,us,ps,nu},{ Hx(ts,xs,us,ps,nu)  });

pt_sym(:,1) = p0_sym;
for it = 2:Nt
   dt = tspan(2) - tspan(1);
   pt_sym(:,it) =  pt_sym(:,it-1) + dt* (  Hx(tspan(it-1),xt_sym(:,it-1),ut_sym(:,it-1),pt_sym(:,it-1),nu)'  );
end
Integrator_adj = casadi.Function('Fadtt',{p0_sym,xt_sym,ut_sym,nu},{pt_sym});

%%
x0 = ones(N,1);
ut = zeros(Nu,Nt);
%
nu_params = linspace(1,5,10);
M = length(nu_params);
% solve equation
xt_cell = cell(1,M);
pt_cell = cell(1,M);
dJ_cell = cell(1,M);
p0_cell = cell(1,M);

LengthStep = 1e-8;

MaxIter = 500;
dJ_history = zeros(MaxIter,1);
for iter = 1:MaxIter
    [ut_new,dJ] = ControlUpdate(xt_cell,pt_cell,dJ_cell,p0_cell,nu_params,ut,x0,Integrator,Integrator_adj,Hu,Psix,tspan,Nt,M,LengthStep,Nu);

    dJ_history(iter) = norm(full(dJ));
    if mod(iter,100) == 1
    fprintf(" iter = "+num2str(iter,'%.4d') + ...
            " | norm(u-uold) = "+num2str(full(norm_fro(ut_new-ut)),'%.2e')+ ...
            " | norm(dJ/du) = "+num2str(dJ_history(iter),'%.3e') +"\n")
    end
    ut = ut_new;
end

%%
iter = 0;
for inu = nu_params
    iter = iter + 1;
    xt_cell{iter} = Integrator(x0,ut,inu);
end
%
figure(1)
clf
subplot(2,1,1)
title('Control State')
hold on
iter = 0;
for inu = nu_params
    iter = iter + 1;
    plot(tspan,full(xt_cell{iter}(1,:))','r')
    plot(tspan,full(xt_cell{iter}(2,:))','b')
end
ylim([-0.5 3.4])

subplot(2,1,2)
plot(tspan,full(ut),'r')
title('Control ')

%
iter = 0;
for inu = nu_params
    iter = iter + 1;
    xt_cell{iter} = Integrator(x0,0*ut,inu);
end
%
figure(2)
clf
subplot(2,1,1)
title('Free State')

hold on
iter = 0;
for inu = nu_params
    iter = iter + 1;
    plot(tspan,full(xt_cell{iter}(1,:))','r')
    plot(tspan,full(xt_cell{iter}(2,:))','b')
end
ylim([-0.5 3.4])

subplot(2,1,2)
plot(tspan,full(0*ut),'r')
title('Control ')

%%
function [ut,dJ] = ControlUpdate(xt_cell,pt_cell,dJ_cell,p0_cell,nu_params,ut,x0,Integrator,Integrator_adj,Hu,Psix,tspan,Nt,M,LengthStep,Nu)
    iter = 0;
    for inu = nu_params
        iter = iter + 1;
        xt_cell{iter} = Integrator(x0,ut,inu);
        % compute final condition of adjoint problem
        p0_cell{iter} = Psix(xt_cell{iter}(:,end),inu);
        % solve adjoint problem
        %
        
        pt_cell{iter} = Integrator_adj(p0_cell{iter},fliplr(xt_cell{iter}),fliplr(ut),inu);
        pt_cell{iter} = fliplr(pt_cell{iter});
        %ts,xs,us,ps,nu
        dJ_cell{iter} = Hu(tspan,xt_cell{iter},ut,pt_cell{iter},inu);
        dJ_cell{iter} = fliplr(reshape(dJ_cell{iter},Nu,Nt));
    end

    dJ = dJ_cell{1};
    for i=2:M 
        dJ = dJ + dJ_cell{i};
    end
    ut = ut - LengthStep*dJ;
end
%%
function [ut,dJ] = ControlUpdateStoch(xt_cell,pt_cell,dJ_cell,p0_cell,nu_params,ut,x0,Integrator,Integrator_adj,Hu,Psix,tspan,Nt,M,LengthStep,Nu)
        iter = 1;
        inu = randsample(nu_params,1);

        xt_cell{iter} = Integrator(x0,ut,inu);
        % compute final condition of adjoint problem
        p0_cell{iter} = Psix(xt_cell{iter}(:,end),inu);
        % solve adjoint problem
        %
        
        pt_cell{iter} = Integrator_adj(p0_cell{iter},fliplr(xt_cell{iter}),fliplr(ut),inu);
        pt_cell{iter} = fliplr(pt_cell{iter});
        %ts,xs,us,ps,nu
        dJ_cell{iter} = Hu(tspan,xt_cell{iter},ut,pt_cell{iter},inu);
        dJ_cell{iter} = fliplr(reshape(dJ_cell{iter},Nu,Nt));
    

        dJ = dJ_cell{1};

        ut = ut - LengthStep*dJ;
end