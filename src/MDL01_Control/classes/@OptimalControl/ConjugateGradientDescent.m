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
    
    T                   = iCP.ode.T;
    tline        =  iCP.ode.tline;
    PT_yt_Depen         = iCP.adjoint.PT.num;
    dH_du               = iCP.gradient.num;

    persistent FreeOde
    persistent ZeroConOde
    if isempty(FreeOde)
        FreeOde = copy(iCP.ode);
        solve(FreeOde)
        
        U_fun  = @(t) interp1(tline,Uold*0,t); 
        Y_fun  = @(t) interp1(tline,FreeOde.Y.num,t);
        
        dP_dt_yuDepen       = iCP.adjoint.F.num;
        dP_dt  = @(t,P) double(dP_dt_yuDepen(T-t,P',Y_fun(T-t)',U_fun(T-t)'))';
        P0 = PT_yt_Depen(T,Y_fun(T)');
        [~,Pfree] = ode45(@(t,P) -dP_dt(t,P),tline,P0);
        Pfree = flipud(Pfree);
        P_fun  = @(t) interp1(tline,Pfree,t);

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
        %%
        ZeroConOde = copy(iCP.ode);
        ZeroConOde.Y0 = ZeroConOde.Y0*0;
        solve(ZeroConOde,'U',Uold)
        
        U_fun  = @(t) interp1(tline,Uold,t); 
        Y_fun  = @(t) interp1(tline,ZeroConOde.Y.num,t);
        
        dP_dt_yuDepen       = iCP.adjoint.F.num;
        dP_dt  = @(t,P) double(dP_dt_yuDepen(T-t,P',Y_fun(T-t)',U_fun(T-t)'))';
        P0 = PT_yt_Depen(T,Y_fun(T)');
        [~,PZC] = ode45(@(t,P) -dP_dt(t,P),tline,P0);
        PZC = flipud(PZC);
        
        P_fun  = @(t) interp1(tline,PZC,t);

        %% Calculo del descenso   
        % Obtenemos du(t)
        du_tDepend = @(t) dH_du(t,Y_fun(t)',P_fun(t)',U_fun(t)');
        % Obtenemos [du(t1) du(t2) du(t3) ...] a partir de la funccion du(t)
        [nrow ncol] = size(Uold);
        duZC = zeros(nrow,ncol);
   
        index = 0;
        for t = tline
            index = index + 1;
            duZC(index,:) = du_tDepend(t);
        end        
        
        ga = duZC - du;
        
        
    else
        
    end
end

