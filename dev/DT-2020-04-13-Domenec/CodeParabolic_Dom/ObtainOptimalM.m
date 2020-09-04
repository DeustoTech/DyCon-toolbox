function [y_out,m_out]=ObtainOptimalM(mu,ibound,Nx,d,Nt,T,Tau,Tau_old,y_old,m_old)
            delta=0.1;

            if d==1
                
                            Linfbound=1;
                            
                            xline = linspace(0,1,Nx);
                            dx = xline(2) - xline(1);
                            
                            N=length(Tau);
                            opti = casadi.Opti();           % CasADi function
                            % ---- Input variables ---------
                            Y = opti.variable(Nx,Nt);     % state trajectory
                            m = opti.variable(Nx,N-1);     %resources
                            % ---- Dynamic constraints --------
                            g=@(j,k) 0;
                            for i=1:N-1
                                   g=@(j,k) g(j,k)+(m(j,i)-Y(j,k))*(k<=Tau(i+1))*(k>Tau(i));
                            end
                            for k=1:Nt-1                              % loop over control intervals
                                for j=2:Nx-1
                                    opti.subject_to(dx^2*(Y(j,k+1)-Y(j,k))==(T/Nt)*(-2*mu*Y(j,k+1)+mu*Y(j+1,k+1)+mu*Y(j-1,k+1)+dx^2*Y(j,k+1)*g(j,k)));
                                end
                                    opti.subject_to(dx^2*(Y(1,k+1)-Y(1,k))==(T/Nt)*(-2*mu*Y(1,k+1)+mu*Y(2,k+1)+mu*Y(2,k+1))+(T/Nt)*(dx^2*Y(1,k+1)*g(1,k)));
                                    opti.subject_to(dx^2*(Y(Nx,k+1)-Y(Nx,k))==(T/Nt)*(-2*mu*Y(Nx,k+1)+mu*Y(Nx-1,k+1)+mu*Y(Nx-1,k+1))+(T/Nt)*(dx^2*Y(Nx,k+1)*g(Nx,k)));
                            end
                            % ---- Control constraints -----------
                            for i=1:N-1
                                for j=1:Nx
                                    opti.subject_to(m(j,i)>=0);
                                    opti.subject_to(m(j,i)<=Linfbound);
                                end
                                opti.subject_to(trapz(m(:,i))*dx<=ibound*Linfbound);
                                opti.subject_to(trapz(m(:,i))*dx>=ibound*Linfbound-delta);
                            end

                            % ---- Optimization objective  ----------
                            opti.minimize(-trapz((Y(:,Nt))));
                            %----- Initial guess ----


                            opti.set_initial(Y, y_old);
                            opti.subject_to(Y(:,1)==y_old(:,1));

                                for k=1:N-2
                                    if Tau(k)==Tau_old(k)
                                          opti.set_initial(m(:,k),m_old(:,k));
                                    end
                                    if Tau(k)~=Tau_old(k)
                                        if Tau(k-1)==Tau_old(k-1)
                                          opti.set_initial(m(:,k),m_old(:,k));
                                        else
                                          opti.set_initial(m(:,k),m_old(:,k-1));
                                        end
                                    end
                                end
                            


                        %---- solve NLP
                        p_opts = struct('expand',true);
                        s_opts = struct('max_iter',10000,'constr_viol_tol',10^(-8),'compl_inf_tol',10^(-8),'acceptable_tol',10^(-10));
                        opti.solver('ipopt',p_opts,s_opts); % set numerical backend

                        tic
                        sol = opti.solve()   % actual solve
                        toc
                        
                        y_out=sol.value(Y);
                        m_out=sol.value(m);

                
            end
            
            if d==2
                            Linfbound=1;
                            xline = linspace(0,1,Nx);
                            dx = xline(2) - xline(1);
                            
                            opti = casadi.Opti();
                            N=length(Tau)-1; % not necessary, just for adapting code
                            Ny=Nx;           % not necessary, just for adapting code
                            Y = opti.variable(Nx*Nx,Nt);
                            m = opti.variable(Nx*Nx,length(Tau)-1); 
                            Resources = opti.variable(Nx,length(Tau)-1);
                            P = opti.variable(Nx);
                            % ---- Dynamic constraints --------
                            g=@(j,k) 0;
                            for i=1:N
                                g=@(j,k) g(j,k)+(m(j,i)-Y(j,k))*(k<=Tau(i+1))*(k>Tau(i));
                            end
                            % (j,i)->j+(i-1)*Nx
                            for k=1:Nt-1                              % loop over control intervals
                                for j=2:Nx-1
                                    for i=2:Nx-1
                                        opti.subject_to(dx^2*(Y(j+(i-1)*Nx,k+1)-Y(j+(i-1)*Nx,k))==(T/Nt)*(-4*mu*Y(j+(i-1)*Nx,k+1)+mu*Y(j+1+(i-1)*Nx,k+1)+mu*Y(j-1+(i-1)*Nx,k+1)+mu*Y(j+(i-1+1)*Nx,k+1)+mu*Y(j+(i-1-1)*Nx,k+1)+dx^2*Y(j+(i-1)*Nx,k+1)*g(j+(i-1)*Nx,k)));
                                    end
                                end
                                %Boundary laterals (1,i)->1+(i-1)*Nx    Nx,i->Nx+(i-1)*Nx
                                for i=2:Nx-1
                                    opti.subject_to(dx^2*(Y(1+(i-1)*Nx,k+1)-Y(1+(i-1)*Nx,k))==(T/Nt)*(-4*mu*Y(1+(i-1)*Nx,k+1)+2*mu*Y(1+1+(i-1)*Nx,k+1)+mu*Y(1+(i-1+1)*Nx,k+1)+mu*Y(1+(i-1-1)*Nx,k+1))+(T/Nt)*(dx^2*Y(1+(i-1)*Nx,k+1)*g(1+(i-1)*Nx,k)));
                                    opti.subject_to(dx^2*(Y(Nx+(i-1)*Nx,k+1)-Y(Nx+(i-1)*Nx,k))==(T/Nt)*(-4*mu*Y(Nx+(i-1)*Nx,k+1)+2*mu*Y(Nx-1+(i-1)*Nx,k+1)+mu*Y(Nx+(i-1+1)*Nx,k+1)+mu*Y(Nx+(i-1-1)*Nx,k+1))+(T/Nt)*(dx^2*Y(Nx+(i-1)*Nx,k+1)*g(Nx+(i-1)*Nx,k)));
                                end
                                        %Boundary laterals (j,1)->j+(1-1)*Nx  (j,Ny)->j+(Ny-1)*Nx

                                for j=2:Nx-1
                                    opti.subject_to(dx^2*(Y(j+(1-1)*Nx,k+1)-Y(j+(1-1)*Nx,k))==(T/Nt)*(-4*mu*Y(j+(1-1)*Nx,k+1)+2*mu*Y(j+(1-1+1)*Nx,k+1)+mu*Y(j+1+(1-1)*Nx,k+1)+mu*Y(j-1+(1-1)*Nx,k+1))+(T/Nt)*(dx^2*Y(j+(1-1)*Nx,k+1)*g(j+(1-1)*Nx,k)));
                                    opti.subject_to(dx^2*(Y(j+(Ny-1)*Nx,k+1)-Y(j+(Ny-1)*Nx,k))==(T/Nt)*(-4*mu*Y(j+(Ny-1)*Nx,k+1)+2*mu*Y(j+(Ny-1-1)*Nx,k+1)+mu*Y(j+1+(Ny-1)*Nx,k+1)+mu*Y(j-1+(Ny-1)*Nx,k+1))+(T/Nt)*(dx^2*Y(j+(Ny-1)*Nx,k+1)*g(j+(Ny-1)*Nx,k)));
                                end
                                        %corners       % (1,1)->1+(1-1)*Nx    %(1,Ny)->1+(Ny-1)*Nx % (Nx,1)->Nx+(1-1)*Nx     % (Nx,Ny)->Nx+(Ny-1)*Nx

                                opti.subject_to(dx^2*(Y(1+(1-1)*Nx,k+1)-Y(1+(1-1)*Nx,k))==(T/Nt)*(-4*mu*Y(1+(1-1)*Nx,k+1)+2*mu*Y(1+1+(1-1)*Nx,k+1)+2*mu*Y(1+(1-1+1)*Nx,k+1)+(T/Nt)*(dx^2*Y(1+(1-1)*Nx,k+1)*g(1+(1-1)*Nx,k))));
                                opti.subject_to(dx^2*(Y(1+(Ny-1)*Nx,k+1)-Y(1+(Ny-1)*Nx,k))==(T/Nt)*(-4*mu*Y(1+(Ny-1)*Nx,k+1)+2*mu*Y(1+1+(Ny-1)*Nx,k+1)+2*mu*Y(1+(Ny-1-1)*Nx,k+1)+(T/Nt)*(dx^2*Y(1+(Ny-1)*Nx,k+1)*g(1+(Ny-1)*Nx,k))));
                                opti.subject_to(dx^2*(Y(Nx+(1-1)*Nx,k+1)-Y(Nx+(1-1)*Nx,k))==(T/Nt)*(-4*mu*Y(Nx+(1-1)*Nx,k+1)+2*mu*Y(Nx-1+(1-1)*Nx,k+1)+2*mu*Y(Nx+(1-1+1)*Nx,k+1)+(T/Nt)*(dx^2*Y(Nx+(1-1)*Nx,k+1)*g(Nx+(1-1)*Nx,k))));
                                opti.subject_to(dx^2*(Y(Nx+(Ny-1)*Nx,k+1)-Y(Nx+(Ny-1)*Nx,k))==(T/Nt)*(-4*mu*Y(Nx+(Ny-1)*Nx,k+1)+2*mu*Y(Nx-1+(Ny-1)*Nx,k+1)+2*mu*Y(Nx+(Ny-1-1)*Nx,k+1)+(T/Nt)*(dx^2*Y(Nx+(Ny-1)*Nx,k+1)*g(Nx+(Ny-1)*Nx,k))));

                            end
                            % ---- Control constraints -----------
                            for i=1:N
                                for j=1:Nx
                                    Resources(j,i)=trapz(m((j-1)*Nx+1:j*Nx,i));
                                    for k=1:Ny
                                        opti.subject_to(m(j+(k-1)*Nx,i)>=0);
                                        opti.subject_to(m(j+(k-1)*Nx,i)<=Linfbound);
                                    end
                                end
                                opti.subject_to(trapz(Resources(:,i))*dx*dx<=ibound*Linfbound);
                                opti.subject_to(trapz(Resources(:,i))*dx*dx>=ibound*Linfbound-delta);
                            end

                            % ---- Optimization objective  ----------
                            for k=1:Nx
                                P(k)=trapz((Y((k-1)*Nx+1:Nx*k,Nt)));
                            end
                                opti.minimize(-trapz(P));



                             for i=1:Nx
                                 for j=1:Nx
                                     opti.subject_to(Y(Nx*(i-1)+j,1)==y_old(i,j,1));
                                     for k=1:Nt
                                           opti.set_initial(Y(Nx*(i-1)+j,k), y_old(i,j,k));
                                     end
                                 end
                             end

                                for k=1:N-1
                                    if Tau(k)==Tau_old(k)
                                        for i=1:Nx
                                            for j=1:Nx
                                                  opti.set_initial(m(Nx*(i-1)+j,k),m_old(i,j,k));
                                            end
                                        end
                                    end
                                    if Tau(k)~=Tau_old(k)
                                        if Tau(k-1)==Tau_old(k-1)
                                            for i=1:Nx
                                                for j=1:Nx
                                                      opti.set_initial(m(Nx*(i-1)+j,k),m_old(i,j,k));
                                                end
                                            end
                                        else
                                            for i=1:Nx
                                                for j=1:Nx
                                                      opti.set_initial(m(Nx*(i-1)+j,k),m_old(i,j,k-1));
                                                end
                                            end
                                        end
                                    end
                                end
                        p_opts = struct('expand',true);
                        s_opts = struct('max_iter',10000,'constr_viol_tol',10^(-5),'compl_inf_tol',10^(-5),'acceptable_tol',10^(-5));
                        opti.solver('ipopt',p_opts,s_opts); % set numerical backend

                        tic
                        sol = opti.solve()   % actual solve
                        toc
                        
                        y_out2=sol.value(Y);
                        m_out2=sol.value(m);
                        
                                
                        y_out=zeros(Nx,Nx,Nt);
                        m_out=zeros(Nx,Nx,N);
                        for i=1:Nx
                            for j=1:Nx
                                y_out(i,j,:)=y_out2(Nx*(i-1)+j,:);
                                m_out(i,j,:)=m_out2(Nx*(i-1)+j,:);
                            end
                        end
        

            end
            
end