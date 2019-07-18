function GetSymbolicalDerivativeState(idynamics)
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

