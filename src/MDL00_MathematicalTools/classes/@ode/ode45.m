function [tspan,StateVector] = ode45(iode,varargin)
%ODE45 Summary of this function goes here
%   Detailed explanation goes here

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