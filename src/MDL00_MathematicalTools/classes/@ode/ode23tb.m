function [tspan,StateVector] = ode23tb(iode,varargin)
%ODE45 Summary of this function goes here
%   Detailed explanation goes here

tspan = iode.tspan;
InitialCondition = iode.InitialCondition;
U = iode.Control.Numeric;

if isempty(varargin)
  try 
      Jacobian = double(iode.Derivatives.State.Sym);
  catch
      Jacobian = [];
  end
  iode.SolverParameters = {odeset('Mass',iode.MassMatrix,'Jacobian',Jacobian)};
else
  iode.SolverParameters{:} = varargin{:};
  iode.SolverParameters{:}.Mass = iode.MassMatrix;
%   try 
%       iode.Jacobian = double(iode.Derivatives.State.Sym);
%   end
end

% [MeshInd,MeshTime] = ndgrid(1:iode.Udim,iode.tspan);
% Uinterp = griddedInterpolant(MeshTime',MeshInd',U);
% Ufun = @(t) arrayfun(@(id) Uinterp(t,id),1:iode.Udim)';

Ufun = @(t) interp1(tspan,U,t,'nearest')';
params = {iode.Params.value};


dynamics = @(t,Y) iode.DynamicEquation.Num(t,Y,Ufun(t),params);

[tspan,StateVector] = ode23tb(dynamics,tspan,InitialCondition,iode.SolverParameters{:});

iode.StateVector.Numeric = StateVector;

end

