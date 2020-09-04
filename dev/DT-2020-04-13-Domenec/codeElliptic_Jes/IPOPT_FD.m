function [y,n]=IPOPT_FD(yy,mm,N,ibound,kappa,mu)


tol=10^(-14);
tol=10^(-7);

xi = 0; xf = 1; % Domain of the problem

% Discretization of the Space
xline = linspace(xi,xf,N);
dx = xline(2) - xline(1);

opt=casadi.Opti();
%% Variables
Y = opt.variable(N,N);     
m = opt.variable(N,N);
%% Dynamics 
i = 2:N-1;
j = 2:N-1;
% inside geometry
expr{1} = mu*(-4*Y(i,j)  + Y(i+1,j)    +  Y(i-1,j) + Y(i,j-1)  +  Y(i,j+1) )   + dx^2*Y(i,j).*(m(i,j)-Y(i,j));
% boundaries conditions 
% x = 0
expr{2} = mu*(-4*Y(1,j)  + Y( 2 ,j)    +  Y(2,j)   + Y(1,j+1)  +  Y(1,j-1) )   + dx^2*Y(1,j).*(m(1,j)-Y(1,j)); 
% x = 1
expr{3} = mu*(-4*Y(N,j)  + Y(N-1,j)    +  Y(N-1,j) + Y(N,j+1)  +  Y(N,j-1) )   + dx^2*Y(N,j).*(m(N,j)-Y(N,j));
% y = 0
expr{4} = mu*(-4*Y(i,1)  + Y(i,2)      +  Y(i,2)   + Y(i+1,1)  +  Y(i-1,1) )   + dx^2*Y(i,1).*(m(i,1)-Y(i,1));
% y = 1
expr{5} = mu*(-4*Y(i,N)  + Y(i,N-1)    +  Y(i,N-1) + Y(i+1,N)  +  Y(i-1,N) )   + dx^2*Y(i,N).*(m(i,N)-Y(i,N));
%%
expr{6} = mu*(-4*Y(1,1)  + 2*Y(2,1)    +  2*Y(1,2)   )  + dx^2*Y(1,1).*( m(1,1) - Y(1,1) );
%
expr{7} = mu*(-4*Y(1,N)  + 2*Y(2,N)    +  2*Y(1,N-1) )  + dx^2*Y(1,N).*( m(1,N) - Y(1,N) );
%
expr{8} = mu*(-4*Y(N,1)  + 2*Y(N-1,1)  +  2*Y(N,2)   )  + dx^2*Y(N,1).*( m(N,1) - Y(N,1) );
%
expr{9} = mu*(-4*Y(N,N)  + 2*Y(N-1,N)  +  2*Y(N,N-1) )  + dx^2*Y(N,N).*( m(N,N) - Y(N,N) );
%% Set dynamics constraints
for iter = 1:9
    opt.subject_to(-tol <= expr{iter}(:)) 
    opt.subject_to(+tol >= expr{iter}(:)) 
%    opt.subject_to(0 == expr{iter}(:)) 
end
%%
% ---- Control constraints -----------

opt.subject_to(m(:)>=0);
opt.subject_to(m(:)<=kappa);
%
opt.subject_to(trapz(trapz(m)')*dx^2<=ibound*kappa);
opt.minimize(-trapz(trapz(Y)'))

opt.set_initial(Y, yy);
opt.set_initial(m, mm);

%% ---- solve NLP              ------
p_opts = struct('expand',true,'print_time',false);
s_opts = struct('print_level',0,'max_iter',10000,'constr_viol_tol',10^(-12),'compl_inf_tol',10^(-12),'acceptable_tol',5*10^(-12));
opt.solver('ipopt',p_opts,s_opts);
        
sol = opt.solve();   % actual solve
        
n=sol.value(m);
y=sol.value(Y);

end