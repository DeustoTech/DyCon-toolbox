function GetSymbolicalHessian(iCP)
%GETHESSIAN Summary of this function goes here
%   Detailed explanation goes here
U = iCP.Dynamics.Control.Symbolic;
Y = iCP.Dynamics.StateVector.Symbolic;
P  =  sym('p', [length(Y),1]);
syms t

iCP.Hessian.Sym = jacobian(formula(iCP.ControlGradient.Sym),U);
iCP.Hessian.Num  = matlabFunction(iCP.Hessian.Sym,'Vars',{t,Y,P,U});

end

