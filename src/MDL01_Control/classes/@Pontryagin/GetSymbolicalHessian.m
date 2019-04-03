function GetSymbolicalHessian(iCP)
%GETHESSIAN Summary of this function goes here
%   Detailed explanation goes here
U = iCP.dynamics.Control.Symbolic;
Y = iCP.dynamics.StateVector.Symbolic;
P  =  sym('p', [length(Y),1]);
syms t

iCP.hessian.Symbolical = jacobian(formula(iCP.ControlGradient.Symbolical),U);
iCP.hessian.Numerical  = matlabFunction(iCP.hessian.Symbolical,'Vars',{t,Y,P,U});

end

