function GetAdjointProblem(iControlProblem)
    syms Hamil t u 
    %%
    Jfun   = iControlProblem.Jfun;
    iode   = iControlProblem.ode;
    
    symL   = Jfun.symL; 
    symPsi = Jfun.symPsi;
    symF   = iode.symF;
    %% Creamos las variables simbolica 
    symU   = iode.symU;
    % Obtenemos el vector Symbolico Y = [y1 y2 y3 ...]^T
    symY   = iode.symY;
    % Creamos el vector Symbolico   P = [p1 p2 p3 ...]
    symP  = SymsVector('p',length(symY),'by','col');
    iControlProblem.P = symP;
    
    %% Hamiltoniano
    Hamil = symL + symP*symF;
    
    
    %% Obtenemos el Gradiente
    % Creamos el problema adjunto  en simbolico
    dP_dt = arrayfun( @(xs) -diff(formula(Hamil),xs), symY.');
    % Convertimos la expresion a una funcion simbolica
    % dP_dt(t,  x1,...,xn,  u1,...,um,  p1,...,pn)
    dP_dt = symfun(dP_dt,[t symP symY.' symU.']);
    % Pasamos esta funcion a una function_handle
    dP_dt = matlabFunction(dP_dt);
    % Por ultimo vectorizamos la function handle 
    %
    % dP_dt (t,P,Y,U) 
    % donde P = [p1 p2 ...], 
    %       X = [y1 y2 ...]
    %       U = [u1 u2 ...], 
    %
    iControlProblem.adjoint.dP_dt = VectorialForm(dP_dt,[t symP symY.' symU.'],'(t,P,Y,U)');
    %% Condicion inicial del problema adjunto
    % Para cada cordenada de X, calculamos la derivada de dPsi/dx_i
    P0 = arrayfun(@(ys) diff(formula(symPsi),ys), symY.');
    % Convertimos la expresion a una funcion simbolica
    % P0(t,  y1,...,yn)
    P0 = symfun(P0,[t symY.']);
    % Pasamos esta funcion a una function_handle
    P0 = matlabFunction(P0);
    % Por ultimo vectorizamos la function handle 
    %
    % P0 (t,Y) 
    % donde Y = [y1 y2 ...], 
    %
    iControlProblem.adjoint.P0 = VectorialForm(P0,[t symY.'],'(t,Y)');
    % 
    %% Direccion del Gradiente
    % Para cada cordenada de U, calculamos la derivada de dH/du_i
    dH_du = arrayfun(@(us) diff(formula(Hamil),us), symU.');
    dH_du = symfun(dH_du,[t symY.' symP symU.']);
    % Pasamos esta funcion a una function_handle
    dH_du = matlabFunction(dH_du);
    % Por ultimo vectorizamos la function handle 
    %
    % dH_du (t,Y,P,U)    
    % donde Y = [y1 y2 ...], 
    %       U = [u1 u2 ...], 
    %       P = [p1 p2 ...]
    
    iControlProblem.dH_du = VectorialForm(dH_du,[t,symY.',symP,symU.'],'(t,Y,P,U)');

end
