clear all
import casadi.*

opt = casadi.Opti();

N = 50;
L = 1;
ds = N/L;

%% Parameters
% dynamics parameter
mu = 0.5;
kappa = 0.5;
%% Variables
theta = opt.variable(N,N);     
m     = opt.variable(N,N);
%% Constraints
% dynamics contraints
I = 2:N-1;
J = 2:N-1;

lap = casadi.MX(N,N);

lap(I,J) = -4*theta(I,J) + theta( I+1 ,  J ) + theta( I-1 , J ) ...
                         + theta(  I  , J+1) + theta(  I  ,J-1);

lap = (1/ds^2)*lap;


opt.subject_to(mu*lap + theta.*(m-theta) == 0)
%
opt.subject_to(theta(:,1) == theta(:,2));
opt.subject_to(theta(1,:) == theta(2,:));

opt.subject_to(theta(:,end) == theta(:,end-1));
opt.subject_to(theta(end,:) == theta(end-1,:));

%

% control constraints
opt.subject_to(m(:)>=0);
opt.subject_to(m(:)<=kappa);
%% Cost Function
opt.minimize(-sum(sum(theta)))
%% Options 
p_opts = struct('expand',true,'print_time',false);
%s_opts = struct('max_iter',10000,'constr_viol_tol',10^(-12),'compl_inf_tol',10^(-12),'acceptable_tol',5*10^(-12),'print_level',0);
%ellOpt.solver('ipopt',p_opts,s_opts);
opt.solver('ipopt');
%% Solve
sol = opt.solve();   % actual solve
%%
figure(1)
subplot(2,1,1)
surf(sol.value(m))
view(0,90)
shading interp
colorbar
colormap jet
%
subplot(2,1,2)
surf(sol.value(theta))
view(0,90)
shading interp
colorbar
colormap jet
