function dHessnew = GetNumericalHessian(iCP,U,Y,P)
%GETNUMERICALHESSIAN Summary of this function goes here
%   Detailed explanation goes here

    Hessian               = iCP.Hessian.Num;
    %
    tspan   =  iCP.ode.tspan;
    %%
    U_fun  = @(t) interp1(tspan,U,t); 
    Y_fun  = @(t) interp1(tspan,Y,t);
    P_fun  = @(t) interp1(tspan,P,t);
    %% Calculo del descenso   
    % Obtenemos du(t)
    du2 = @(t) Hessian(t,Y_fun(t)',P_fun(t)',U_fun(t)');
    % Obtenemos [du(t1) du(t2) du(t3) ...] a partir de la funccion du(t)
    [nrow ncol] = size(U);
    dHessnew = zeros(ncol,ncol,nrow);
   
    index = 0;
    for t = tspan
        index = index + 1;
        dHessnew(:,:,index) = du2(t);
    end
    
end

