function solve(iODE,varargin)
% description: 
% autor: JOroya
% MandatoryInputs:   
%  iODE: 
%    description: List of ODEs
%    class: ControlProblem
%    dimension: [1x1]
% OptimalParmaters:

    
    p = inputParser;

    addRequired(p,'iODE') 
    addOptional(p,'Control',iODE.Control.Numeric)
    addOptional(p,'RKMethod',iODE.RKMethod)
    addOptional(p,'RKParameters',iODE.RKParameters)

    parse(p,iODE,varargin{:})

    Control             = p.Results.Control;
    RKMethod            = p.Results.RKMethod;
    RKParameters        = p.Results.RKParameters;
    
    iODE.RKMethod = RKMethod;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isempty(Control)
       if iODE.lineal
            Control = zeros(length(iODE.tspan),iODE.Udim);
       else
            Control = zeros(length(iODE.tspan),length(iODE.Control.Symbolic));
       end
    end

    %%
    U_fun   = @(t)   interp1(iODE.tspan,Control,t)';   

    switch iODE.Type
        case 'InitialCondition'
            dY_dt   = @(t,Y) double(iODE.Dynamic.Numeric(t,Y,U_fun(t)));
            % RungeKuttaMethod can be ode45
            [~,iODE.VectorState.Numeric] = RKMethod(dY_dt,iODE.tspan,iODE.Condition,RKParameters{:});
        case 'FinalCondition'
            T = iODE.FinalTime;
            dY_dt   = @(t,Y) -double(iODE.Dynamic.Numeric(T-t,Y,U_fun(T-t)));
            % RungeKuttaMethod can be ode45
            [~,iODE.VectorState.Numeric] = RKMethod(dY_dt,iODE.tspan,iODE.Condition,RKParameters{:});
            iODE.VectorState.Numeric = flipud(iODE.VectorState.Numeric);            
    end

    iODE.Control.Numeric = Control;
end


