function [tspan,StateVector] = ode45(iode,varargin)
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


%Uinterp = arrayfun( @(ui) griddedInterpolant(tspan,U(:,ui)),1:iode.Udim,'UniformOutput',false);
%Ufun = @(t) arrayfun( @(ui) Uinterp{ui}(t),1:iode.Udim).';
%Ufun = @(t) interp1(tspan,U,t)';

Ufun = @(t) interp1(tspan,U,t)';
params = {iode.Params.value};

dynamics = @(t,Y) iode.DynamicEquation.Num(t,Y,Ufun(t),params);

% if ~isempty(iode.Derivatives.State.Num)
%      iode.SolverParameters{:}.Jacobian = @(t,Y) iode.Derivatives.State.Num(t,Y,Ufun(t),params);
% end

if iode.FixedNt 
    [tspan,StateVector] = ode45(dynamics,tspan,InitialCondition,iode.SolverParameters{:});
else
    oldtspan = tspan;
    [tspan,StateVector] = ode45(dynamics,[tspan(1) tspan(end)],InitialCondition,iode.SolverParameters{:});
    iode.Nt = length(tspan);
    
    iode.Control.Numeric = interp1(oldtspan,U,tspan);
end
iode.StateVector.Numeric = StateVector;


end


function result = interp(tspan,U,t)
    [~ ,index] = min(abs(t-tspan));
    result = U(index,:);
end