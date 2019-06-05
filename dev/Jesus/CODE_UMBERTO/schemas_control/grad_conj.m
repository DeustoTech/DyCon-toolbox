function [f,it]=grad_conj(idyn,dual,epsilon,tol,f,YT)
    %%
        
    %%
    [~ ,soly_libre] = solve(idyn);
    secmem=soly_libre(end,:)';

    %%
    dual.InitialCondition = f;
    [~ ,solphi] =solve(dual);
    solphi = flipud(solphi);
    
    %%
    idyn.InitialCondition = 0*f;
    [~ ,soly] = solve(idyn,'Control',solphi*idyn.B);
    Lambdaf=soly(end,:)';
    
    %%
    g = (1/epsilon)*(Lambdaf + secmem - YT) +f;
    
    
    w=g;

    erreurinit = sqrt(g'*g);


    erreur_gradconj=10*tol;
    it=0;

    tic
    while (erreur_gradconj>tol) 

        it=it+1;
        
        dual.InitialCondition = w;
        [~ ,solphi] =solve(dual);
        solphi = flipud(solphi);
        
        idyn.InitialCondition = 0*w;
        [~ ,soly] = solve(idyn,'Control',(idyn.B'*solphi')');
        Lambdaw=soly(end,:)';
    
    
	    newg = (1/epsilon)*Lambdaw + w;

        rho = (g'*g)/(newg'*w);

    
        f=f-rho*w;
        newg = g - rho*newg;

        
        erreur_gradconj = sqrt(newg'*newg)/erreurinit;

        gamma=  (newg'*newg)/(g'*g);

        w=newg+ gamma*w;
        g=newg;
        fprintf("Iteration %g - Error %4.3e \n",it,erreur_gradconj);


    end

    

end
