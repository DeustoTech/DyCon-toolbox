function Y=ObtainEllipticSolution(m,mu,N)
    
    dx=1/N;

    opt=casadi.Opti();
    y = opt.variable(N,N);

    grad_y_sq = (1/dx^2)*((y(N,N)-y(N-1,N))^2+(y(N,N)-y(N,N-1))^2);
    for i=1:N-1
        for j=1:N-1
            grad_y_sq=grad_y_sq+(1/dx^2)*((y(i,j)-y(i+1,j))^2+(y(i,j)-y(i,j+1))^2);
        end
    end
    
    
    for j=1:N-1
        grad_y_sq=grad_y_sq+(1/dx^2)*((y(N,j)-y(N-1,j))^2+(y(N,j+1)-y(N,j))^2);
    end
    for i=1:N-1
        grad_y_sq=grad_y_sq+(1/dx^2)*((y(i+1,N)-y(i,N)).^2+(y(i,N)-y(i,N-1)).^2);
    end
    
    opt.minimize(mu*0.5*dx*grad_y_sq-0.5*dx*trapz(trapz(m.*(y.^2))')+1/3*dx*trapz(trapz(y.^3)'))
    
    opt.set_initial(y,m);
    
    p_opts = struct('expand',true,'print_time',false);
    s_opts = struct('print_level',0,'max_iter',10000,'constr_viol_tol',10^(-12),'compl_inf_tol',10^(-12),'acceptable_tol',5*10^(-12));
    opt.solver('ipopt',p_opts,s_opts);
    
    try
        sol = opt.solve();   % actual solve
        Y=sol.value(y);
    catch
        fprintf('\n IPOPT FAILED finding the solution \n\n')
        Y=zeros(N,N);
    end


end



