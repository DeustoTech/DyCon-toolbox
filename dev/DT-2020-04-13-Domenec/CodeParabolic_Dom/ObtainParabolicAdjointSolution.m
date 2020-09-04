function p=ObtainParabolicAdjointSolution(y,m,mu,Nx,d,Nt,T,Tau)
    if d==1
        A=2*eye(Nx,Nx)+diag(-ones(Nx-1,1),1)+diag(-ones(Nx-1,1),-1);
        A(1,2)=2*A(1,2);
        A(Nx,Nx-1)=2*A(Nx,Nx-1);
        for k=1:Nt
            for ep=2:length(Tau)
                if ((k>Tau(ep-1))*(k<=Tau(ep))==1)
                    km=ep;
                end
            end
            
            for i=1:Nx
               dd(i)=-(m(i,km-1)-2*y(i,k)); 
            end
            Out(:,:,k)=mu*(1/Nx)^2*A-diag(dd);
        end
        
        p=ones(Nx,Nt);
        for k=1:Nt-1
           p(:,Nt-k)=(eye(Nx)-(T/Nt)*Out(:,Nt-k))\p(:,Nt-k+1);
        end

    end
    if d==2
        %rmk, take note that, y and m is in the matricial form, we must convert it
%         for i=1:Nx
%             for j=1:Nx
%                 Y(Nx*(i-1)+j,:)=y(i,j,:);
%                 M(Nx*(i-1)+j,:)=m(i,j,:);
%             end
%         end

        
        
        A=4*eye(Nx,Nx)+diag(-ones(Nx-1,1),1)+diag(-ones(Nx-1,1),-1);
        A(1,2)=2*A(1,2);
        A(Nx,Nx-1)=2*A(Nx,Nx-1);


        Ar = repmat(A, 1, Nx);                                   % Repeat Matrix
        Ac = mat2cell(Ar, size(A,1), repmat(size(A,2),1,Nx));    % Create Cell Array Of Orignal Repeated Matrix
        Out0 = blkdiag(Ac{:});
        
        Out0=Out0+diag(-ones(Nx*Nx-Nx,1),Nx)+diag(-ones(Nx*Nx-Nx,1),-Nx);

        for i=1:Nx
                   Out0(i,Nx+i)=2*Out0(i,Nx+i);
                   Out0(Nx*Nx-Nx+i,Nx*Nx-2*Nx+i)=2*Out0(Nx*Nx-Nx+i,Nx*Nx-2*Nx+i);
        end
        Out0=mu*(1/Nx)^2*Out0;
        
        for k=1:Nt
            for ep=2:length(Tau)
                if ((k>Tau(ep-1))*(k<=Tau(ep))==1)
                    km=ep;
                end
            end
            for i=1:Nx*Nx
               dd(i)=-(m(1+fix((i-1)/Nx),1+rem(i-1,Nx),km-1)-2*y(1+fix((i-1)/Nx),1+rem(i-1,Nx),k));
            end
            Out(:,:,k)=Out0-diag(dd');
        end

        
         P=ones(Nx*Nx,Nt);
        for k=1:Nt-1
           P(:,Nt-k)=(eye(Nx*Nx)-(T/Nt)*Out(:,:,Nt-k))\P(:,Nt-k+1);
        end
        
        p=zeros(Nx,Nx,Nt);
       
        for i=1:Nx
            for j=1:Nx
                p(i,j,:)=P(Nx*(i-1)+j,:);
            end
        end
    end


end
