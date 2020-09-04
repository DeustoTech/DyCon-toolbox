%% Gradient descent with IpOpt help
function [yy,mm]=gradientElliptic(mu,d,Nx,kappa,ibound,NR)
%% set m_0

% NR=20;
% 
% kappa=1;
% ibound=0.6;
% Nx=60;
% d=2;  %dimension
% mu=0.001; %diffusivity
emergency=0;
%% Random IpOpt initialization

massDef=0;
for i=1:NR
    m=randominitial(Nx,d,ibound,kappa);
    mDef=m;
    y=ObtainEllipticSolution(m,mu,Nx,d);

    
        yNew=zeros(Nx,(d-1)*Nx);
        mNew=zeros(Nx,(d-1)*Nx);
        [yNew , mNew]= IPOPT_FD(y,m,Nx,ibound,kappa,mu,d);
        
        %mNew=m;
        
        yNew=ObtainEllipticSolution(mNew,mu,Nx,d);
    if d==1
        massNew=trapz(yNew);
    end
    if d==2
        massNew=trapz(trapz(yNew)');
    end
    
    if massNew>massDef
        massDef=massNew;
        mDef=mNew;
    end
    
    if (i==NR)*(massDef==0)
        i=i-1;
        emergency=emergency+1;
    end
    if emergency==10
        i=NR;
    end
    
end
m=mDef;
y=ObtainEllipticSolution(m,mu,Nx,d);


%% Gradient descent
iter=1;
maxit=3000;

tol=10^(-5);
y=0;
res=2*tol;
    delta=0.1;

while(iter<maxit && res>tol)
    fprintf(strcat('Iter ',num2str(iter),': Check Gradient+ Armijo rule, residuu=',num2str(res),' \n'));
    if d==1
        figure(1)
            plot(m);
    end
    if d==2
        figure(1)
            surf(m);
    end
    y_old=y;
    fprintf(strcat('Iter ',num2str(iter),': Obtain Elliptic \n'));
    y=ObtainEllipticSolution(m,mu,Nx,d);
    fprintf(strcat('Iter ',num2str(iter),': Obtain Adjoint \n'));
    p=ObtainAdjointSolution(y,m,mu,Nx,d);
    fprintf(strcat('Iter ',num2str(iter),': Obtain AdmissiblePerturbation \n'));
    h=ObtainAdmissiblePerturbation(y,p,m,Nx,kappa,d);
    m_old=m;
    
    m=m+delta*h;
    fprintf(strcat('Iter ',num2str(iter),': Check Gradient+ Armijo rule \n'));
    ycheck=ObtainEllipticSolution(m,mu,Nx,d);
    if d==1
        while trapz(ycheck)<trapz(y);
             delta=delta/2;
             m=m_old+delta*h;
             ycheck=ObtainEllipticSolution(m,mu,Nx,d);
        end
    end
    if d==2
        while trapz(trapz(ycheck)')<trapz(trapz(y)');
             delta=delta/2;
             m=m_old+delta*h;
             ycheck=ObtainEllipticSolution(m,mu,Nx,d);
        end
    end
    delta=2*delta;
        y=ycheck;

    if d==1
            mass{iter}=trapz(y)*(1/Nx);
    end
    if d==2
            mass{iter}=trapz(trapz(y)')*(1/Nx)^2;
    end
    
    res=max(max(y-y_old));
    
    iter=iter+1;
end

yy=y;
mm=m;

end
