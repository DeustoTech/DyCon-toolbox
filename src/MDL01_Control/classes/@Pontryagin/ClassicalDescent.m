function  [Unew ,Ynew,Jnew] = ClassicalDescent(iCP,Uold,Yold,Jold,varargin)
%  description: This method is able to update the value of the control by decreasing 
%               the value of the functional. By calculating the gradient, $ \\frac{dH}{du}$. Also, it is decremented 
%               in that direction, assuring the decrease by the adaptive step size. 
%  little_description: This method is able to update the value of the control by decreasing the value of the functional. 
%  autor: JOroya
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
%  OptionalInputs:
%    InitialLengthStep: 
%        description: This parameter is the step size if the MiddleStepControl option is false. 
%                       If the option MiddleStepControl is activated then this parameter is the initial step
%                       of the methodo but then the step is doubled in the case where the functional iteration 
%                       decreases and is divided by two its the functional one grows.
%        class: double
%        dimension: [1x1]
%    MinLengthStep: 
%        description: It may happen that although we divide the step of the descenco many times,
%                       we continue to obtain an update that increases the value of the functional. In this case,
%                       it is necessary to have a minimum step size to avoid infinite loops. This parameter is
%                       responsible for this.
%        class: double
%        dimension: [1x1]
%    MiddleStepControl: 
%        description: If this parameter is enabled, it allows the algorithm to search for different 
%                       step-logitudes, provided that the control update decrements the functional value. If it is
%                       deactivated, the descent of the gradient will be constant.
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

    addOptional(p,'InitialLengthStep',1e-1)
    addOptional(p,'MinLengthStep',1e-8)
    addOptional(p,'MiddleStepControl',true)
    
    parse(p,iCP,Uold,Yold,Jold,varargin{:})
    
    InitialLengthStep   = p.Results.InitialLengthStep;
    MinLengthStep       = p.Results.MinLengthStep;
    MiddleStepControl   = p.Results.MiddleStepControl;
    %%
    
    persistent LengthMemory
    
    if isempty(LengthMemory) 
        LengthMemory = InitialLengthStep;
    else
        InitialLengthStep = LengthMemory;
    end
    
    %
    %% Empezamos con un LengthStep
    LengthStep =2*InitialLengthStep;
    while true 
        % en cada iteracion dividimos el LengthStep
        LengthStep = LengthStep/2;
        %
        [UTry, YTry] = ClassicalDescentUpdateControl(iCP,Uold,Yold,LengthStep);
        % Calculate functional value
        JTry = GetFunctional(iCP,YTry,UTry);
        %%
     
        if ((JTry - Jold) <= 0)||~MiddleStepControl
            Unew = UTry;
            Ynew = YTry;
            Jnew = JTry;
            %
            LengthMemory = 2*LengthStep;
            return
        end
        if (LengthStep <= MinLengthStep)
            Unew = Uold;
            Ynew = Yold;
            Jnew = Jold;
            

            return
        end
    end
   
end
%%
%%
%%
function [Unew,Ynew] = ClassicalDescentUpdateControl(iCP,Uold,Yold,LengthStep)
        
    %% Recupereamos las variables para empezar el problema 
    dP_dt_yuDepen       = iCP.adjoint.F.num;
    PT_yt_Depen         = iCP.adjoint.PT.num;
    dH_du               = iCP.gradient.num;
    T                   = iCP.ode.FinalTime;
    

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
    dP_dt  = @(t,P) double(dP_dt_yuDepen(T-t,P',Y_fun(T-t)',U_fun(T-t)'))';
    % Obtenemos la condicion final del problema adjunto
    P0 = PT_yt_Depen(T,Y_fun(T)');
    % Resolvemos el problema dual, colcando un 
    % signo negativo y luego inviertiendo en el tiempo la solucion
    [~,P] = ode45(@(t,P) -dP_dt(t,P),tline,P0);
    P = flipud(P);
    % Obtenemos la funcion p(t) a partir p = [p(t1) p(t2) ... ]
    P_fun  = @(t) interp1(tline,P,t);
    
    %% Calculo del descenso   
    % Obtenemos du(t)
    du_tDepend = @(t) dH_du(t,Y_fun(t)',P_fun(t)',U_fun(t)');
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
    solve(iCP.ode,'Control',Unew);
    Ynew = iCP.ode.VectorState.Numeric;
    
    % Obtenemos x(t)
end
