function GetSymHamiltonian(iCP)
%GETSYMHAMILTONIAN Summary of this function goes here
%   Detailed explanation goes here
t = iCP.Dynamics.symt;
Y = iCP.Dynamics.StateVector.Symbolic;
U = iCP.Dynamics.Control.Symbolic;
P = iCP.Adjoint.Dynamics.StateVector.Symbolic;
    Params = iCP.Dynamics.Params;
L = iCP.Functional.Lagrange.Sym;
F = iCP.Dynamics.DynamicEquation.Sym;
    
iCP.Hamiltonian.Sym = formula(P.'*F + L);
iCP.Hamiltonian.Num = matlabFunction(iCP.Hamiltonian.Sym,'Vars',{t,Y,U,P});

end

