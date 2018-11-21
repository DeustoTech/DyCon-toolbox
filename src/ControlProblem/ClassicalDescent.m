function [u,X] = ClassicalDescent(Descent_Struct,u0)
    %% Recupereamos las variables para empezar el problema 
    iCP                 = Descent_Struct.iControlProblem;
    dX_dt_uDepen        = Descent_Struct.dX_dt_uDepen;
    dP_dt_xuDepen       = Descent_Struct.dP_dt_xuDepen;
    P0_xt_Depen         = Descent_Struct.P0_xt_Depen;
    dH_du               = Descent_Struct.dH_du;
    T                   = Descent_Struct.T;
    %
    tline   =  iCP.ode.tline;
    X0      =  iCP.ode.X0;
    %% Resolvemos el problem primal
    % Creamos u(t)  = [u1(t)  u2(t)];
    %
    % a partir de u = [u1(t1) u2(t1);
    %                  u1(t2) u2(t2);  
    %                  u1(t3) u2(t3);      
    %                  . . . . . . . ]

    U_fun   = @(t)   interp1(tline,u0,t);   
    % Creamos dX/dt (t,X)  a partir de la funcion dx_dt_uDepen    
    dX_dt   = @(t,X) double(dX_dt_uDepen(t,X,U_fun(t)));
    
    % Obtenemos x = [x(t1) x(t2) ... ] 
    [~,X] = ode45(dX_dt,tline,X0);
    % Obtenemos x(t)
    X_fun  = @(t) interp1(tline,X,t);

    %% Resolvemos el problem dual
    % Creamos dp/dt (t,p)  a partir de la funcion dp_dt_xuDepen
    dP_dt  = @(t,P) double(dP_dt_xuDepen(t,P,X_fun(t),U_fun(t)))';
    % Obtenemos la condicion final del problema adjunto
    P0 = P0_xt_Depen(T,X_fun(T));
    % Resolvemos el problema dual, colcando un 
    % signo negativo y luego inviertiendo en el tiempo la solucion
    [~,P] = ode45(@(t,P) -dP_dt(t,P),tline,P0);
    P = flipud(P);
    % Obtenemos la funcion p(t) a partir p = [p(t1) p(t2) ... ]
    P_fun  = @(t) interp1(tline,P,t);
    
    %% Calculo del descenso   
    % Obtenemos du(t)
    du_tDepend = @(t) dH_du(t,X_fun(t),P_fun(t),U_fun(t));
    % Obtenemos [du(t1) du(t2) du(t3) ...] a partir de la funccion du(t)
    [nrow ncol] = size(u0);
    du = zeros(nrow,ncol);
   
    index = 0;
    for t = tline
        index = index + 1;
        du(index,:) = du_tDepend(t);
    end
   
    u = u0 - 0.1*du;
    
end
