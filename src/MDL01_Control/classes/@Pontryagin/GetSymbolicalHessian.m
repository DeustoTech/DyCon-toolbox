function GetSymbolicalHessian(iCP)
%GETHESSIAN Summary of this function goes here
%   Detailed explanation goes here
U = iCP.Dynamics.Control.Symbolic;
Y = iCP.Dynamics.StateVector.Symbolic;
P  =  sym('p', [length(Y),1]);
syms t

iCP.Hessian.Symbolical = jacobian(formula(iCP.ControlGradient.Symbolical),U);
iCP.Hessian.Numerical  = matlabFunction(iCP.Hessian.Symbolical,'Vars',{t,Y,P,U});

end

