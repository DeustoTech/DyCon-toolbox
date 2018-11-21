function [dP_dt, P0,dH_du] = GetAdjointProblem(iControlProblem)
    syms Hamil t u 
    %%
    Jfun   = iControlProblem.Jfun;
    iode   = iControlProblem.ode;
    
    symL   = Jfun.symL; 
    symPsi = Jfun.symPsi;
    symF   = iode.symF;
    %% Creamos las variables simbolica 
    symU   = iode.symU;
    % Obtenemos el vector Symbolico X = [x1 x2 x3 ...]^T
    symX   = iode.symX;
    % Creamos el vector Symbolico   P = [p1 p2 p3 ...]
    symP  = SymsVector('p',length(symX),'by','col');
    iControlProblem.P = symP;
    
    %% Hamiltoniano
    Hamil = symL + symP*symF;
    
    
    %% Obtenemos el Gradiente
    % Creamos el problema adjunto  en simbolico
    dP_dt = arrayfun( @(xs) -diff(formula(Hamil),xs), symX.');
    % Convertimos la expresion a una funcion simbolica
    % dP_dt(t,  x1,...,xn,  u1,...,um,  p1,...,pn)
    dP_dt = symfun(dP_dt,[t symP symX.' symU.']);
    % Pasamos esta funcion a una function_handle
    dP_dt = matlabFunction(dP_dt);
    % Por ultimo vectorizamos la function handle 
    %
    % dP_dt (t,P,X,U) 
    % donde P = [p1 p2 ...], 
    %       X = [x1 x2 ...]
    %       U = [u1 u2 ...], 
    %
    dP_dt = VectorialForm(dP_dt,[t symP symX.' symU.'],'(t,P,X,U)');
    %% Condicion inicial del problema adjunto
    % Para cada cordenada de X, calculamos la derivada de dPsi/dx_i
    P0 = arrayfun(@(xs) diff(formula(symPsi),xs), symX.');
    % Convertimos la expresion a una funcion simbolica
    % P0(t,  x1,...,xn)
    P0 = symfun(P0,[t symX.']);
    % Pasamos esta funcion a una function_handle
    P0 = matlabFunction(P0);
    % Por ultimo vectorizamos la function handle 
    %
    % P0 (t,X) 
    % donde X = [x1 x2 ...], 
    %
    P0 = VectorialForm(P0,[t symX.'],'(t,X)');
    % 
    %% Direccion del Gradiente
    % Para cada cordenada de U, calculamos la derivada de dH/du_i
    dH_du = arrayfun(@(us) diff(formula(Hamil),us), symU.');
    dH_du = symfun(dH_du,[t symX.' symP symU.']);
    % Pasamos esta funcion a una function_handle
    dH_du = matlabFunction(dH_du);
    % Por ultimo vectorizamos la function handle 
    %
    % dH_du (t,X,P,U)    
    % donde X = [x1 x2 ...], 
    %       U = [u1 u2 ...], 
    %       P = [p1 p2 ...]
    
    dH_du = VectorialForm(dH_du,[t,symX.',symP,symU.'],'(t,X,P,U)');

end
