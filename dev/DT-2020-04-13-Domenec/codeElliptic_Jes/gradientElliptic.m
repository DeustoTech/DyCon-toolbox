%% Gradient descent with IpOpt help
function [yy,mm]=gradientElliptic(mu,Nx,kappa,ibound,NR)
%% set m_0

emergency=0;
%% Random IpOpt initialization

massDef=0;
for i=1:NR
    m=randominitial(Nx,ibound,kappa);
    mDef=m;
    y=ObtainEllipticSolution(m,mu,Nx);

    [yNew , mNew]= IPOPT_FD(y,m,Nx,ibound,kappa,mu);
        
        
        yNew=ObtainEllipticSolution(mNew,mu,Nx);

        massNew=trapz(trapz(yNew)');
    
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

%% Gradient descent
iter=1;
maxit=3000;

tol=10^(-5);
y=0;
res=2*tol;

delta=0.1;

delta=1e-5;

minLength = 1e-6;

fin = false;
while(iter<maxit && res>tol)
    fprintf(strcat('Iter ',num2str(iter),': Check Gradient+ Armijo rule, residuu=',num2str(res),' \n'));

    y_old=y;
    fprintf(strcat('mu = ',num2str(mu),' | Iter ',num2str(iter),': Obtain Elliptic \n'));
    y=ObtainEllipticSolution(m,mu,Nx);
    fprintf(strcat('Iter ',num2str(iter),': Obtain Adjoint \n'));
    p=ObtainAdjointSolution(y,m,mu,Nx);
    fprintf(strcat('Iter ',num2str(iter),': Obtain AdmissiblePerturbation \n'));
    h=ObtainAdmissiblePerturbation(y,p,m,Nx,kappa);
    m_old=m;
    
    m=m+delta*h;
    fprintf(strcat('Iter ',num2str(iter),': Check Gradient+ Armijo rule \n'));
    ycheck=ObtainEllipticSolution(m,mu,Nx);

        while trapz(trapz(ycheck)')<trapz(trapz(y)')
             delta=delta/10;
             m=m_old+delta*h;
             ycheck=ObtainEllipticSolution(m,mu,Nx);
             fprintf("delta = "+delta+"\n")
             if minLength > delta
                fin = true;
                break  
             end
        end
    
    if fin
        break
    end
    delta=2*delta;
    y=ycheck;


    mass{iter}=trapz(trapz(y)')*(1/Nx)^2;
    
    
    res=max(max(y-y_old));
    
    iter=iter+1;
end

yy=y;
mm=m;

end
