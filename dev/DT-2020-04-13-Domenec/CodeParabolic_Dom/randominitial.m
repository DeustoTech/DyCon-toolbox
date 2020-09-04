function m=randominitial(Nx,d,ibound,kappa)
dx=1/Nx;
if d==1
    rng shuffle
    a=rand(1,5)-0.5;
    b=rand(1,5)-0.5;
    m=zeros(Nx,1);
    for k=1:5
        for i=1:Nx
                 m(i)=m(i)+a(k)*cos(pi*i*dx)+b(k)*sin(pi*i*dx); 
        end
    end
    m=m+kappa*rand(1,1);
    m=(m-min(m));
    m=(kappa*ibound/trapz(m*dx))*m;
    if max(m)>kappa
        m=kappa*(m)/max(m);
    end
end

if d==2
    rng shuffle
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


end
