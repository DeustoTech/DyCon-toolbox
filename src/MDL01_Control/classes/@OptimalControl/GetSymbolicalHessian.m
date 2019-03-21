function GetSymbolicalHessian(iCP)
%GETHESSIAN Summary of this function goes here
%   Detailed explanation goes here
U = iCP.ode.Control.Symbolic;
Y = iCP.ode.StateVector.Symbolic;
P  =  sym('p', [length(Y),1]);
syms t

iCP.hessian.sym = jacobian(formula(iCP.gradient.sym),U);

iCP.hessian.num = matlabFunction(iCP.hessian.sym,'Vars',{t,Y,P,U});

end

