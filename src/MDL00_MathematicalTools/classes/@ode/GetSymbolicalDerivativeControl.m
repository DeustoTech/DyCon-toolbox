function GetSymbolicalDerivativeControl(idynamics)
%GETSYMBOLICALDERIVATIVECONTROL Summary of this function goes here
%   Detailed explanation goes here

if isempty(idynamics.DynamicEquation.Symbolical) 
    GetSymbolicalDynamics(idynamics)
end

t  = idynamics.symt; 
Y  = idynamics.StateVector.Symbolic;
U  = idynamics.Control.Symbolic;
f  = idynamics.DynamicEquation.Symbolical;

fU = jacobian(f,U);

idynamics.DerivativeDynControl.Symbolical = fU;
idynamics.DerivativeDynControl.Numerical = matlabFunction(fU,'Vars',{t,Y,U});
end

