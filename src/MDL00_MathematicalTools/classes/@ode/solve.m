function [tspan,Y] = solve(iODE,varargin)
% description: The ode class, if only de organization of ode.
%               The solve of this class is the RK family.
% autor: JOroya
% OptionalInputs:
%   DynamicEquation: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
%   StateVector: 
%       description: StateVector
%       class: Symbolic
%       dimension: [1x1]
%   Control: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
%   A: 
%       description: simbolic expresion
%       class: matrix
%       dimension: [1x1]
%   B: 
%       description: simbolic expresion
%       class: matrix
%       dimension: [1x1]            
%   InitialControl:
%       name: Initial Control 
%       description: matrix 
%       class: double
%       dimension: [length(iCP.tspan)]
%       default:   empty   
    
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
