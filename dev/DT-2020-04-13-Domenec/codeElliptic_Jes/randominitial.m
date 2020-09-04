function m=randominitial(Nx,ibound,kappa)
dx=1/Nx;


    %rng shuffle
    rng(100)
    a=rand(1,5)-0.5;
    b=rand(1,5)-0.5;
    m=zeros(Nx,Nx);
    for k=1:5
        for i=1:Nx
            for j=1:Nx
                 m(i,j)=m(i,j)+a(k)*cos(pi*i*dx)*cos(pi*j*dx)+b(k)*sin(pi*i*dx)*sin(pi*j*dx); 
            end
        end
    end
    m=m+kappa*rand(1,1);
    m=(m-min(min(m)));
    m=(kappa*ibound/trapz(trapz(m)*dx))*m;
    if max(m)>kappa
        m=kappa*(m)/max(m);
    end



end
