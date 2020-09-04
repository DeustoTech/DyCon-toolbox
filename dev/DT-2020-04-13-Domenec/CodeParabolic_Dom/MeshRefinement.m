
function Tau2=MeshRefinement(y,p,m,d,Tau,Nx)

    if d==1
            weight=zeros(length(Tau)-1,1);
            for i=2:length(Tau)
                opti = casadi.Opti();           % CasADi function
                nt2=Tau(i);
                nt1=Tau(i-1);
                Y=y(:,nt1+1:nt2);
                P=p(:,nt1+1:nt2);
                H =opti.variable(Nx,nt2-nt1);
                for j=1:nt2-nt1
                   opti.subject_to(sum(H(:,j))==0);
                   for k=1:Nx
                       opti.subject_to(H(k,j)+m(k,i-1)<=1);
                       opti.subject_to(H(k,j)+m(k,i-1)>=0);
                   end
                end
                opti.minimize(-sum((Y(:).*P(:).*H(:))));
                p_opts = struct('expand',true);
                s_opts = struct('max_iter',1000,'constr_viol_tol',10^(-6),'compl_inf_tol',10^(-6),'acceptable_tol',5*10^(-6));
                opti.solver('ipopt',p_opts,s_opts);
                tic
                sol = opti.solve();   % actual solve
                toc
                HH=sol.value(H);
                weight(i-1)=sum((Y(:).*P(:).*HH(:)));

            end
            Tau2=Tau;
            
            [maxx,interval]=max(weight);
            
           newt=floor(0.5*(Tau(interval+1)+Tau(interval)));
           %check precision
           marker=0;
           for i=1:length(Tau)
               if newt==Tau(i)
                   marker=1;
               end
           end
           if marker==0
               Tau2(length(Tau)+1)=newt;
               Tau2=sort(Tau2);
           end
           if marker==1
               Tau2=Tau;
           end
           
          


    end
    
    if d==2
                    weight=zeros(length(Tau)-1,1);
            for i=2:length(Tau)
                opti = casadi.Opti();           % CasADi function
                nt2=Tau(i);
                nt1=Tau(i-1);
                Y=y(:,:,nt1+1:nt2);
                P=p(:,:,nt1+1:nt2);
                H =opti.variable(Nx*Nx,nt2-nt1);
                for j=1:nt2-nt1
                   opti.subject_to(sum(H(:,j))==0);
                   for k=1:Nx*Nx
                       opti.subject_to(H(k,j)+m(1+fix((k-1)/Nx),1+rem(k-1,Nx),i-1)<=1);
                       opti.subject_to(H(k,j)+m(1+fix((k-1)/Nx),1+rem(k-1,Nx),i-1)>=0);
                   end
                end
                opti.minimize(-sum((Y(:).*P(:).*H(:))));
                p_opts = struct('expand',true);
                s_opts = struct('max_iter',1000,'constr_viol_tol',10^(-6),'compl_inf_tol',10^(-6),'acceptable_tol',5*10^(-6));
                opti.solver('ipopt',p_opts,s_opts);
                tic
                sol = opti.solve();   % actual solve
                toc
                HH=sol.value(H);
                weight(i-1)=sum((Y(:).*P(:).*HH(:)));

            end
            Tau2=Tau;
            
            [maxx,interval]=max(weight);
            
            newt=floor(0.5*(Tau(interval+1)+Tau(interval)));
            %check precision
            marker=0;
            for i=1:length(Tau)
                if newt==Tau(i)
                       marker=1;
                end
            end
            if marker==0
                   Tau2(length(Tau)+1)=newt;
                Tau2=sort(Tau2);
            end
            if marker==1
                   Tau2=Tau;
            end

    end


    
    
end