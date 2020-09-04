function p=ObtainAdjointSolution(y,m,mu,Nx,d)
    if d==1
        A=2*eye(Nx,Nx)+diag(-ones(Nx-1,1),1)+diag(-ones(Nx-1,1),-1);
        A(1,2)=2*A(1,2);
        A(Nx,Nx-1)=2*A(Nx,Nx-1);
        for i=1:Nx
           d(i)=m(i)-2*y(i); 
        end
        Out=mu*(1/Nx)^2*A-diag(d);
        p=Out\ones(Nx,1);

    end
    if d==2
        A=4*eye(Nx,Nx)+diag(-ones(Nx-1,1),1)+diag(-ones(Nx-1,1),-1);
        A(1,2)=2*A(1,2);
        A(Nx,Nx-1)=2*A(Nx,Nx-1);


        Ar = repmat(A, 1, Nx);                                   % Repeat Matrix
        Ac = mat2cell(Ar, size(A,1), repmat(size(A,2),1,Nx));    % Create Cell Array Of Orignal Repeated Matrix
        Out = blkdiag(Ac{:});

        Out=Out+diag(-ones(Nx*Nx-Nx,1),Nx)+diag(-ones(Nx*Nx-Nx,1),-Nx);

        for i=1:Nx
                   Out(i,Nx+i)=2*Out(i,Nx+i);
                   Out(Nx*Nx-Nx+i,Nx*Nx-2*Nx+i)=2*Out(Nx*Nx-Nx+i,Nx*Nx-2*Nx+i);
        end
        Out=mu*(1/Nx)^2*Out;
        for i=1:Nx*Nx
           d(i)=m(1+fix((i-1)/Nx),1+rem(i-1,Nx))-2*y(1+fix((i-1)/Nx),1+rem(i-1,Nx)); 
        end
        Out=Out-diag(d);
        
        P=Out\ones(Nx*Nx,1);
        p=zeros(Nx,Nx);
        for i=1:Nx
            for j=1:Nx
                p(i,j)=P(Nx*(i-1)+j);
            end
        end
    end


end
