function [tspan, sol] = euleri(iode,varargin)
    
    if ~iode.lineal
       error('This ode can not solve by euleri because it is not lineal') 
    end
    %%
    A                = iode.A;
    B                = iode.B;
    M                = iode.MassMatrix;
    InitialCondition = iode.InitialCondition;
    U                = iode.Control.Numeric;
    
    tspan = iode.tspan;

    [N,~] = size(A);
    StepsTime = length(tspan);
    sol = zeros(N,StepsTime);
    sol(:,1) = InitialCondition;
    
    %% NO ESTA PENSADO PARA TSPAN NO UNIFORME
    dt = tspan(2) - tspan(1);
    C=speye(N,N)-dt*(M\A);

    if ~isempty(B)

        for i=2:StepsTime
            sol(:,i) = C\sol(:,i-1) + dt*( (M\B)*U(i-1,:)' );
        end
    
    else
        
        for i=2:StepsTime
            sol(:,i) = C\sol(:,i-1);
        end
        
    end
    sol = sol';
    
end