function varargout = LinearFordwardEuler(iode,varargin)
  
    %% Setting and Validation of Input Parameters  
    p = inputParser;

    addRequired(p,'iode')
    addOptional(p,'Control',ZerosControl(iode))
    parse(p,iode,varargin{:})
    % Catch Optional Parameters in variable with short name
    U = p.Results.Control;
    %%
    CompatibleControl(iode,U);

    %%
    A                = iode.A;
    B                = iode.B;
    C                = iode.C;
    InitialCondition = iode.InitialCondition;
    
    tspan = iode.tspan;

    [N,~] = size(A);
    Nt = length(tspan);
    sol = zeros(N,Nt);
    sol(:,1) = InitialCondition;
    
    %% NO ESTA PENSADO PARA TSPAN NO UNIFORME
    dt = tspan(2) - tspan(1);

    if ~isempty(B)

        for i=2:Nt
            sol(:,i) = C\(sol(:,i-1) + dt*( B*U(:,i-1)));
        end
    
    else
        
        for i=2:Nt
            sol(:,i) = C\sol(i-1,:);
        end
        
    end
%% Setting Output Parameters
switch nargout
    case 1
        varargout{1} = sol;
end    
end