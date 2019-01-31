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
    addOptional(p,'RungeKuttaMethod',@ode45)
    

    parse(p,iODE,varargin{:})

    Control             = p.Results.Control;
    RungeKuttaMethod    = p.Results.RungeKuttaMethod;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isempty(Control)
       if iODE.lineal
            Control = zeros(length(iODE.tline),iODE.Udim);
       else
            Control = zeros(length(iODE.tline),length(iODE.Control.symbolic));
       end
    end

    %%
    U_fun   = @(t)   interp1(iODE.tline,Control,t)';   

    switch iODE.Type
        case 'InitialCondition'
            dY_dt   = @(t,Y) double(iODE.Dynamic.Numeric(t,Y,U_fun(t)));
            % RungeKuttaMethod can be ode45
            [~,iODE.VectorState.Numeric] = RungeKuttaMethod(dY_dt,iODE.tline,iODE.Condition);
        case 'FinalCondition'
            T = iODE.FinalTime;
            dY_dt   = @(t,Y) -double(iODE.Dynamic.Numeric(T-t,Y,U_fun(T-t)));
            % RungeKuttaMethod can be ode45
            [~,iODE.VectorState.Numeric] = RungeKuttaMethod(dY_dt,iODE.tline,iODE.Condition);
            iODE.VectorState.Numeric = flipud(iODE.VectorState.Numeric);            
    end

    iODE.Control.Numeric = Control;
end


