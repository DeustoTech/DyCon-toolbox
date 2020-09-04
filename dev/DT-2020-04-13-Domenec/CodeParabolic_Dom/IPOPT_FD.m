function [y,n]=IPOPT_FD(yy,mm,Nx,ibound,kappa,mu,d)

L=1;
    tol=10^(-14);

if d==2
    Ny=Nx;
    xi = 0; xf = L; % Domain of the problem
    delta=0.1;

    % Discretization of the Space
    xline = linspace(xi,xf,Nx);
    %xline = xline(2:end-1);
    dx = xline(2) - xline(1);

    ellOpt=casadi.Opti();


    Y = ellOpt.variable(Nx,Ny);     
    m = ellOpt.variable(Nx,Ny);

        for j=2:Nx-1
            for k=2:Ny-1
               ellOpt.subject_to(-tol<=(-4*mu*Y(j,k)+mu*Y(j+1,k)+mu*Y(j-1,k)+mu*Y(j,k-1)+mu*Y(j,k+1)+dx^2*Y(j,k)*(m(j,k)-Y(j,k))));
               ellOpt.subject_to(tol>=(-4*mu*Y(j,k)+mu*Y(j+1,k)+mu*Y(j-1,k)+mu*Y(j,k-1)+mu*Y(j,k+1)+dx^2*Y(j,k)*(m(j,k)-Y(j,k))));
            end
        end

            for i=2:Ny-1
                ellOpt.subject_to(tol>=(-4*mu*Y(1,i)+mu*Y(2,i)+mu*Y(2,i)+mu*Y(1,i+1)+mu*Y(1,i-1))+(dx^2*Y(1,i)*(m(1,i)-Y(1,i))));
                ellOpt.subject_to(-tol<=(-4*mu*Y(1,i)+mu*Y(2,i)+mu*Y(2,i)+mu*Y(1,i+1)+mu*Y(1,i-1))+(dx^2*Y(1,i)*(m(1,i)-Y(1,i))));

                ellOpt.subject_to(tol>=(-4*mu*Y(Nx,i)+mu*Y(Nx-1,i)+mu*Y(Nx-1,i)+mu*Y(Nx,i+1)+mu*Y(Nx,i-1))+(dx^2*Y(Nx,i)*(m(Nx,i)-Y(Nx,i))));
                ellOpt.subject_to(-tol<=(-4*mu*Y(Nx,i)+mu*Y(Nx-1,i)+mu*Y(Nx-1,i)+mu*Y(Nx,i+1)+mu*Y(Nx,i-1))+(dx^2*Y(Nx,i)*(m(Nx,i)-Y(Nx,i))));

            end

            for j=2:Nx-1
                ellOpt.subject_to(tol>=(-4*mu*Y(j,1)+mu*Y(j,2)+mu*Y(j,2)+mu*Y(j+1,1)+mu*Y(j-1,1))+(dx^2*Y(j,1)*(m(j,1)-Y(j,1))));
                ellOpt.subject_to(tol>=(-4*mu*Y(j,Ny)+mu*Y(j,Ny-1)+mu*Y(j,Ny-1)+mu*Y(j+1,Ny)+mu*Y(j-1,Ny))+(dx^2*Y(j,Ny)*(m(j,Ny)-Y(j,Ny))));

                ellOpt.subject_to(-tol<=(-4*mu*Y(j,1)+mu*Y(j,2)+mu*Y(j,2)+mu*Y(j+1,1)+mu*Y(j-1,1))+(dx^2*Y(j,1)*(m(j,1)-Y(j,1))));
                ellOpt.subject_to(-tol<=(-4*mu*Y(j,Ny)+mu*Y(j,Ny-1)+mu*Y(j,Ny-1)+mu*Y(j+1,Ny)+mu*Y(j-1,Ny))+(dx^2*Y(j,Ny)*(m(j,Ny)-Y(j,Ny))));
            end

            ellOpt.subject_to(tol>=(-4*mu*Y(1,1)+2*mu*Y(2,1)+2*mu*Y(1,2)+(dx^2*Y(1,1)*(m(1,1)-Y(1,1)))));
            ellOpt.subject_to(tol>=(-4*mu*Y(1,Ny)+2*mu*Y(2,Ny)+2*mu*Y(1,Ny-1)+(dx^2*Y(1,Ny)*(m(1,Ny)-Y(1,Ny)))));
            ellOpt.subject_to(tol>=(-4*mu*Y(Nx,1)+2*mu*Y(Nx-1,1)+2*mu*Y(Nx,2)+(dx^2*Y(Nx,1)*(m(Nx,1)-Y(Nx,1)))));
            ellOpt.subject_to(tol>=(-4*mu*Y(Nx,Ny)+2*mu*Y(Nx-1,Ny)+2*mu*Y(Nx,Ny-1)+(dx^2*Y(Nx,Ny)*(m(Nx,Ny)-Y(Nx,Ny)))));

            ellOpt.subject_to(-tol<=(-4*mu*Y(1,1)+2*mu*Y(2,1)+2*mu*Y(1,2)+(dx^2*Y(1,1)*(m(1,1)-Y(1,1)))));
            ellOpt.subject_to(-tol<=(-4*mu*Y(1,Ny)+2*mu*Y(2,Ny)+2*mu*Y(1,Ny-1)+(dx^2*Y(1,Ny)*(m(1,Ny)-Y(1,Ny)))));
            ellOpt.subject_to(-tol<=(-4*mu*Y(Nx,1)+2*mu*Y(Nx-1,1)+2*mu*Y(Nx,2)+(dx^2*Y(Nx,1)*(m(Nx,1)-Y(Nx,1)))));
            ellOpt.subject_to(-tol<=(-4*mu*Y(Nx,Ny)+2*mu*Y(Nx-1,Ny)+2*mu*Y(Nx,Ny-1)+(dx^2*Y(Nx,Ny)*(m(Nx,Ny)-Y(Nx,Ny)))));

    % ---- Control constraints -----------
    %     m is limited
        for j=1:Nx
            for i=1:Ny
                ellOpt.subject_to(m(j,i)>=0);
                ellOpt.subject_to(m(j,i)<=kappa);
            end
        end


         ellOpt.subject_to(trapz(trapz(m)')*dx^2<=ibound*L*kappa);
         %ellOpt.subject_to(trapz(trapz(m)')*dx^2>=ibound*2*L*kappa-delta);
        ellOpt.minimize(-trapz(trapz(Y)'))
    for i=1:Nx
        for j=1:Ny
            ellOpt.set_initial(Y(i,j), yy(i,j));
            ellOpt.set_initial(m(i,j), mm(i,j));
        end
    end


    %% ---- solve NLP              ------
        p_opts = struct('expand',true);
        s_opts = struct('max_iter',10000,'constr_viol_tol',10^(-12),'compl_inf_tol',10^(-12),'acceptable_tol',5*10^(-12));
        ellOpt.solver('ipopt',p_opts,s_opts);
        tic
        sol = ellOpt.solve();   % actual solve
        toc



    n=sol.value(m);
    y=sol.value(Y);

    
end
if d==1
        xi = 0; xf = L; % Domain of the problem
    delta=0.1;

    % Discretization of the Space
    xline = linspace(xi,xf,Nx);
    %xline = xline(2:end-1);
    dx = xline(2) - xline(1);

    opti = casadi.Opti();  % CasADi function
    %% ----  variables ---------
    Y = opti.variable(Nx); % state
    m = opti.variable(Nx)
    %% ---- constraints --------
       for j=2:Nx-1
           opti.subject_to(-tol<=(-2*mu*Y(j)+mu*Y(j+1)+mu*Y(j-1)+dx^2*Y(j)*(m(j)-Y(j))));
           opti.subject_to(tol>=(-2*mu*Y(j)+mu*Y(j+1)+mu*Y(j-1)+dx^2*Y(j)*(m(j)-Y(j))));
       end
           opti.subject_to(tol>=(-2*mu*Y(1)+2*mu*Y(2))+(dx^2*Y(1)*(m(1)-Y(1))));
           opti.subject_to(-tol<=(-2*mu*Y(1)+2*mu*Y(2))+(dx^2*Y(1)*(m(1)-Y(1))));
           opti.subject_to(-tol<=(-2*mu*Y(Nx)+2*mu*Y(Nx-1))+(dx^2*Y(Nx)*(m(Nx)-Y(Nx))));
           opti.subject_to(tol>=(-2*mu*Y(Nx)+2*mu*Y(Nx-1))+(dx^2*Y(Nx)*(m(Nx)-Y(Nx))));

    %% ---- Control constraints -----------
    %     m is limited
        for j=1:Nx
            opti.subject_to(m(j)>=0);
            opti.subject_to(m(j)<=kappa);
        end
        % Integral constraint
            opti.subject_to(trapz(m)*(L)/Nx<=ibound*L*kappa);
            %opti.subject_to(trapz(m)*(L)/Nx>=ibound*L*kappa-delta);


    %% ---- Optimization objective  ----------
    opti.minimize(-trapz(Y))
    %% ---- initial guesses for solver ---
    for i=1:Nx
            opti.set_initial(Y(i), yy(i));
            opti.set_initial(m(i), mm(i));
    end

    %% ---- solve NLP              ------
    p_opts = struct('expand',true);
    s_opts = struct('max_iter',5000,'constr_viol_tol',10^(-6),'compl_inf_tol',10^(-6));
    opti.solver('ipopt',p_opts,s_opts);

    tic
    sol = opti.solve();   % actual solve
    toc
    n=sol.value(m);
    y=sol.value(Y);



    
end


end