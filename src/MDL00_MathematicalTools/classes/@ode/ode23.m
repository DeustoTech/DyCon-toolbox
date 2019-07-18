function [tspan,StateVector] = ode23(iode,varargin)
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

tspan = iode.tspan;
InitialCondition = iode.InitialCondition;
U = iode.Control.Numeric;

if isempty(varargin)
  iode.SolverParameters = {odeset('Mass',iode.MassMatrix)};
else
  iode.SolverParameters{:} = varargin{:};
  iode.SolverParameters{:}.Mass = iode.MassMatrix;
end

Ufun = @(t) interp1(tspan,U,t)';
params = {iode.Params.value};

dynamics = @(t,Y) iode.DynamicEquation.Num(t,Y,Ufun(t),params);

[tspan,StateVector] = ode23(dynamics,tspan,InitialCondition);

iode.StateVector.Numeric = StateVector;

end

