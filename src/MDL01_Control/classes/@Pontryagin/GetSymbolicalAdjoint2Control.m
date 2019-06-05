function GetSymbolicalAdjoint2Control(iCP)
%GETSYMBOLICALADJOINT2CONTROL Summary of this function goes here
%   Detailed explanation goes here
solution = solve(iCP.ControlGradient.Symbolical == 0,iCP.Dynamics.Control.Symbolic);


U = arrayfun(@(u) solution.(u{:}),fieldnames(solution));
U = U.';
t    = iCP.Dynamics.symt;
symP = iCP.Adjoint.P.';

iCP.Adjoint2Control.Symbolical =  symfun(U,[t symP.']);

iCP.Adjoint2Control.Numerical  = matlabFunction(iCP.Adjoint2Control.Symbolical,'Vars',{t,symP.'});

  
end

