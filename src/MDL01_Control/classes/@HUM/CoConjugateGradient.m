function f = CoConjugateGradient(iHUM,f,varargin)

    p = inputParser;
    addRequired(p,'iHUM');
    addRequired(p,'f');
    addOptional(p,'tol',1e-3)
    
    parse(p,iHUM,f,varargin{:})
    
    xline = iHUM.Dynamics.mesh{1};
    dx = xline(2) - xline(1);

    M   =  iHUM.Dynamics.MassMatrix; 
    B   =  iHUM.Dynamics.B;
    
    mesh = iHUM.Dynamics.mesh{1};
    x = [-1,mesh,1];
    himd = x(2:end-1)-x(1:end-2);
    hipd = x(3:end)-x(2:end-1);
    hi = 0.5*(hipd+himd);
    I  = diag(hi);
    %%
    %I   =  dx*eye(iHUM.Dynamics.StateDimension);
    
    %%
    Bstart = ((I\B)')*M;

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
    
    [~ ,Y] = solve(iHUM.zerodynamics,'Control',P*Bstart');
    Yend=Y(end,:)';
    
    %%
    df = (Yend + YFreeEnd - YT) +iHUM.Epsilon*f;
    
    w=df;

    initerr = sqrt(df'*M*df);
    err=10*tol;
    
    it = 0;
    
    while (err>tol) 
        it = it + 1;
        iHUM.Adjoint.InitialCondition = w;
        [~ ,P] =solve(iHUM.Adjoint);
        P = flipud(P);
        
        % Initial Condition is cero!
        Control = P*Bstart';
        [~ ,Y] = solve(iHUM.zerodynamics,'Control',Control);
        Lambdaw=Y(end,:)';
    
    
	    dfnew = Lambdaw + iHUM.Epsilon*w;

        rho = (df'*M*df)/(dfnew'*M*w);

    
        f=f-rho*w;
        dfnew = df - rho*dfnew;

        err = sqrt(dfnew'*M*dfnew)/initerr;
        
        display("iter = "+num2str(it,'%.4d')+"  |  error = "+err)

        gamma=  (dfnew'*M*dfnew)/(df'*M*df);

        w=dfnew+ gamma*w;
        df=dfnew;


    end

    
    iHUM.Adjoint.InitialCondition = f;
    [~ ,P] =solve(iHUM.Adjoint);
    P = flipud(P);
    
    Control = (iHUM.Dynamics.B'*P')';
    [~ ,Y] = solve(iHUM.Dynamics,'Control',Control);
    

end
