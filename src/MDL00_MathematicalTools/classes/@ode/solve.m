function [tspan,Y] = solve(iODE,varargin)
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
    addOptional(p,'Solver',iODE.Solver)
    addOptional(p,'SolverParameters',iODE.SolverParameters)

    parse(p,iODE,varargin{:})

    Control           = p.Results.Control;
    Solver            = p.Results.Solver;
    SolverParameters  = p.Results.SolverParameters;
    % Update ode properties
    iODE.Solver           = Solver;
    iODE.SolverParameters = SolverParameters;
    iODE.Control.Numeric  = Control;
    
    % Execute with Solver of ode
    [~,iODE.StateVector.Numeric] = Solver(iODE,SolverParameters{:});

    % return tspan and vector sate
    tspan = iODE.tspan;
    Y     = iODE.StateVector.Numeric;
end
