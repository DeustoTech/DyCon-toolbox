function Y=ObtainEllipticSolution(m,mu,Nx,d)
dx=1/Nx;
if d==1
    ellOpt=casadi.Opti();
    y = ellOpt.variable(Nx,1);
%      grad_y_sq = ellOpt.variable(Nx,1);
%     for i=1:Nx-1
%             ellOpt.subject_to(grad_y_sq(i)==(1/dx^2)*((y(i+1)-y(i))^2));
%     end
%     ellOpt.subject_to(grad_y_sq(Nx)==(1/dx^2)*((y(Nx)-y(Nx-1))^2));
%         ellOpt.minimize(mu*0.5*dx*trapz(grad_y_sq)-0.5*dx*trapz(m.*(y.^2))+1/3*dx*trapz(y.^3));
        grad_y_sq=(1/dx^2)*((y(1+1)-y(1))^2);
    for i=2:Nx-1
            grad_y_sq=grad_y_sq+(1/dx^2)*((y(i+1)-y(i))^2);
    end
    grad_y_sq=grad_y_sq+(1/dx^2)*((y(Nx)-y(Nx-1))^2);
        ellOpt.minimize(mu*0.5*dx*grad_y_sq-0.5*dx*trapz(m.*(y.^2))+1/3*dx*trapz(y.^3));     
        
        
    % Apply regularization on m
    
           A=2*eye(length(m))+diag(-ones(length(m)-1,1),1)+diag(-ones(length(m)-1,1),-1);
        A(1,2)=2*A(1,2);
        A(length(m),length(m)-1)=2*A(length(m),length(m)-1); 
        ellOpt.set_initial(y,(m-0.5*(1/length(m)^2)*A*m));

    p_opts = struct('expand',true);
    s_opts = struct('max_iter',10000,'constr_viol_tol',10^(-6),'compl_inf_tol',10^(-6),'acceptable_tol',5*10^(-6));
    ellOpt.solver('ipopt',p_opts,s_opts);
    error=0;
    tic
        try
    sol = ellOpt.solve();   % actual solve
    catch
        fprintf('\n IPOPT FAILED finding the solution \n\n')
        error=1;
        Y=zeros(Nx,1);

    end
    toc
    if error==0
        Y=sol.value(y);
    end
end

if d==2
    ellOpt=casadi.Opti();
    y = ellOpt.variable(Nx,Nx);
%      grad_y_sq = ellOpt.variable(Nx,Nx);
%     for i=1:Nx-1
%         for j=1:Nx-1
%             ellOpt.subject_to(grad_y_sq(i,j)==(1/dx^2)*((y(i+1,j)-y(i,j))^2+(y(i,j+1)-y(i,j))^2));
%         end
%     end
%     for j=1:Nx-1
%         ellOpt.subject_to(grad_y_sq(Nx,j)==(1/dx^2)*((y(Nx,j)-y(Nx-1,j))^2+(y(Nx,j+1)-y(Nx,j))^2));
%     end
%     for i=1:Nx-1
%         ellOpt.subject_to(grad_y_sq(i,Nx)==(1/dx^2)*((y(i+1,Nx)-y(i,Nx)).^2+(y(i,Nx)-y(i,Nx-1)).^2));
%     end
%     ellOpt.subject_to(grad_y_sq(Nx,Nx)==(1/dx^2)*((y(Nx,Nx)-y(Nx-1,Nx))^2+(y(Nx,Nx)-y(Nx,Nx-1))^2));
    
         grad_y_sq = (1/dx^2)*((y(Nx,Nx)-y(Nx-1,Nx))^2+(y(Nx,Nx)-y(Nx,Nx-1))^2);
    for i=1:Nx-1
        for j=1:Nx-1
            grad_y_sq=grad_y_sq+(1/dx^2)*((y(i+1,j)-y(i,j))^2+(y(i,j+1)-y(i,j))^2);
        end
    end
    for j=1:Nx-1
        grad_y_sq=grad_y_sq+(1/dx^2)*((y(Nx,j)-y(Nx-1,j))^2+(y(Nx,j+1)-y(Nx,j))^2);
    end
    for i=1:Nx-1
        grad_y_sq=grad_y_sq+(1/dx^2)*((y(i+1,Nx)-y(i,Nx)).^2+(y(i,Nx)-y(i,Nx-1)).^2);
    end
    
        ellOpt.minimize(mu*0.5*dx*grad_y_sq-0.5*dx*trapz(trapz(m.*(y.^2))')+1/3*dx*trapz(trapz(y.^3)'))

        
        %ellOpt.minimize(mu*0.5*dx*trapz(trapz(grad_y_sq)')-0.5*dx*trapz(trapz(m.*(y.^2))')+1/3*dx*trapz(trapz(y.^3)'))
    
        ellOpt.set_initial(y,m);
    p_opts = struct('expand',true);
    s_opts = struct('max_iter',10000,'constr_viol_tol',10^(-12),'compl_inf_tol',10^(-12),'acceptable_tol',5*10^(-12));
    ellOpt.solver('ipopt',p_opts,s_opts);
    error=0;
    tic
    try
    sol = ellOpt.solve();   % actual solve
    catch
        fprintf('\n IPOPT FAILED finding the solution \n\n')
        error=1;
        Y=zeros(Nx,Nx);

    end
    toc
    if error==0
        Y=sol.value(y);
    end

end



end
