function GetSymbolicalDerivativeState(idynamics)
%GETSYMBOLICALDERIVATIVESTATE Summary of this function goes here
%   Detailed explanation goes here

if isempty(idynamics.DynamicEquation.Symbolical) 
    GetSymbolicalDynamics(idynamics)
end


t  = idynamics.symt; 
Y  = idynamics.StateVector.Symbolic;
U  = idynamics.Control.Symbolic;
f  = idynamics.DynamicEquation.Symbolical;

fY = jacobian(f,Y);

idynamics.DerivativeDynState.Symbolical = fY;
idynamics.DerivativeDynState.Numerical = matlabFunction(fY,'Vars',{t,Y,U});

end

