function f = CoConjugateGradient(iHUM,f,varargin)

    p = inputParser;
    addRequired(p,'iHUM');
    addRequired(p,'f');
    addOptional(p,'tol',1e-3)
    
    parse(p,iHUM,f,varargin{:})
    
    tol = p.Results.tol;
    
    YT = iHUM.Target;
    %% Calculamos la solucion sin control
    [~ ,YFree] = solve(iHUM.Dynamics);
    YFreeEnd=YFree(end,:)';

    %%
    iHUM.Adjoint.InitialCondition = f;
    [~ ,P] =solve(iHUM.Adjoint);
    P = flipud(P);
    
    %%
    [~ ,Y] = solve(iHUM.zerodynamics,'Control',P*iHUM.zerodynamics.B);
    Yend=Y(end,:)';
    
    %%
    df = (1/iHUM.Epsilon)*(Yend + YFreeEnd - YT) +f;
    
    w=df;

    initerr = sqrt(df'*df);
    err=10*tol;
    
    it = 0;
    while (err>tol) 
        it = it + 1;
        iHUM.Adjoint.InitialCondition = w;
        [~ ,P] =solve(iHUM.Adjoint);
        P = flipud(P);
        
        % Initial Condition is cero!
        Control = (iHUM.Dynamics.B'*P')';
        [~ ,Y] = solve(iHUM.zerodynamics,'Control',Control);
        Lambdaw=Y(end,:)';
    
    
	    dfnew = (1/iHUM.Epsilon)*Lambdaw + w;

        rho = (df'*df)/(dfnew'*w);

    
        f=f-rho*w;
        dfnew = df - rho*dfnew;

        err = sqrt(dfnew'*dfnew)/initerr

        gamma=  (dfnew'*dfnew)/(df'*df);

        w=dfnew+ gamma*w;
        df=dfnew;


    end

    
    iHUM.Adjoint.InitialCondition = f;
    [~ ,P] =solve(iHUM.Adjoint);
    P = flipud(P);
    
    Control = (iHUM.Dynamics.B'*P')';
    [~ ,Y] = solve(iHUM.Dynamics,'Control',Control);
    

end
