function GetSymbolicalDerivativeControl(idynamics)
%GETSYMBOLICALDERIVATIVECONTROL Summary of this function goes here
%   Detailed explanation goes here

if isempty(idynamics.DynamicEquation.Sym) 
    GetSymbolicalDynamics(idynamics)
end

t  = idynamics.symt; 
Y  = idynamics.StateVector.Symbolic;
U  = idynamics.Control.Symbolic;
f  = idynamics.DynamicEquation.Sym;

Params   = [idynamics.Params.sym].';    
if isempty(Params) 
    Params = sym.empty;
end

fU = jacobian(f,U);

idynamics.Derivatives.Control.Sym = fU;
idynamics.Derivatives.Control.Num = matlabFunction(fU,'Vars',{t,Y,U,Params});
end

