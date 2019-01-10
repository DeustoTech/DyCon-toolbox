function  [Unew ,Ynew,Jnew] = ConjugateGradientDescent(iCP,Uold,Yold,Jold,varargin)
%  description: This method is able to update the value of the control by decreasing 
%               the value of the functional. By calculating the gradient, $ \\frac{dH}{du}$. Also, it is decremented 
%               in that direction, assuring the decrease by the adaptive step size. 
%  autor: UmbertoB
%  MandatoryInputs:   
%    iCP: 
%        description: Control Problem Object
%        class: ControlProblem
%        dimension: [1x1]
%    UOld: 
%        description: Control Vector in time  
%        class: double
%        dimension: [M,iCP.tline]
%    YOld: 
%        description: State Vector in time 
%        class: double
%        dimension: [length(iCP.ode.Y0),iCP.tline]
%    JOld: 
%        description: Value of functional J(Uold,Yold)
%        class: double
%        dimension: [length(iCP.ode.Y0),iCP.tline]
%  Outputs:
%    Unew:
%        description: Update of Control Vector  
%        class: double
%        dimension: [Mxlength(iCP.tline)]
%    Ynew:
%        description: Update of State Vector 
%        class: double
%        dimension: [length(iCP.tline)]
%    Jnew:
%        description: New Value of functional 
%        class: double
%        dimension: [1x1]

    p = inputParser;
    addRequired(p,'iCP')
    addRequired(p,'Uold')
    addRequired(p,'Yold')
    addRequired(p,'Jold')
    
    parse(p,iCP,Uold,Yold,Jold,varargin{:})
    
    %
    %% Recupereamos las variables para empezar el problema 
    dP_dt_yuDepen       = iCP.adjoint.dP_dt;
    P0_yt_Depen         = iCP.adjoint.P0;
    dH_du               = iCP.dH_du;
    T                   = iCP.T;
    
    %
    tline   =  iCP.ode.tline;
    %%
    
    % Creamos u(t)  = [u1(t)  u2(t)];
    %
    % a partir de u = [u1(t1) u2(t1);
    %                  u1(t2) u2(t2);  
    %                  u1(t3) u2(t3);      
    %                  . . . . . . . ]
    U_fun  = @(t) interp1(tline,Uold,t); 

    Y_fun  = @(t) interp1(tline,Yold,t);
    
    %% Resolvemos el problem dual
    % Creamos dp/dt (t,p)  a partir de la funcion dp_dt_xuDepen
    dP_dt  = @(t,P) double(dP_dt_yuDepen(t,P,Y_fun(t),U_fun(t)))';
    % Obtenemos la condicion final del problema adjunto
    P0 = P0_yt_Depen(T,Y_fun(T));
    % Resolvemos el problema dual, colcando un 
    % signo negativo y luego inviertiendo en el tiempo la solucion
    [~,P] = ode45(@(t,P) -dP_dt(t,P),tline,P0);
    P = flipud(P);
    % Obtenemos la funcion p(t) a partir p = [p(t1) p(t2) ... ]
    P_fun  = @(t) interp1(tline,P,t);
    
    %% Calculo del descenso   
    % Obtenemos du(t)
    du_tDepend = @(t) dH_du(t,Y_fun(t),P_fun(t),U_fun(t));
    % Obtenemos [du(t1) du(t2) du(t3) ...] a partir de la funccion du(t)
    [nrow ncol] = size(Uold);
    du = zeros(nrow,ncol);
   
    index = 0;
    for t = tline
        index = index + 1;
        du(index,:) = du_tDepend(t);
    end
    %% Actualizamos  Control
        
    Unew = Uold - LengthStep*du; 
   
    %% Resolvemos el problem primal
    solve(iCP.ode,'U',Unew);
    Ynew = iCP.ode.Y;
    
    % Obtenemos x(t)
    Jnew = GetFunctional(iCP,Ynew,Unew);
end
