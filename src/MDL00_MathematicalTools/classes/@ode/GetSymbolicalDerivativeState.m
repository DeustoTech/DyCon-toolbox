function GetSymbolicalDerivativeState(idynamics)
%GETSYMBOLICALDERIVATIVESTATE Summary of this function goes here
%   Detailed explanation goes here

if isempty(idynamics.DynamicEquation.Sym) 
    GetSymbolicalDynamics(idynamics)
end


t  = idynamics.symt; 
Y  = idynamics.StateVector.Symbolic;
U  = idynamics.Control.Symbolic;
f  = idynamics.DynamicEquation.Sym;
Params   = [idynamics.Params.sym];    
if isempty(Params) 
    Params = sym.empty;
end
fY = jacobian(f,Y);


idynamics.Derivatives.State.Sym = fY;
idynamics.Derivatives.State.Num = matlabFunction(fY,'Vars',{t,Y,U,Params});

end

