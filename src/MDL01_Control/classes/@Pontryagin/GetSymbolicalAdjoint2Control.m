function GetSymbolicalAdjoint2Control(iCP)
%GETSYMBOLICALADJOINT2CONTROL Summary of this function goes here
%   Detailed explanation goes here
t = iCP.Dynamics.symt;
Y = iCP.Dynamics.StateVector.Symbolic;
U = iCP.Dynamics.Control.Symbolic;
P = iCP.Adjoint.Dynamics.StateVector.Symbolic;
    Params = iCP.Dynamics.Params;

if isempty(iCP.ControlGradient.Sym)

    iCP.ControlGradient.Sym = iCP.ControlGradient.Num(t,Y,P,U,sym.empty);
end
solution = solve(iCP.ControlGradient.Sym == 0,iCP.Dynamics.Control.Symbolic);


U = arrayfun(@(u) solution.(u{:}),fieldnames(solution));
U = U.';
t    = iCP.Dynamics.symt;
%%
iCP.AnalyticalControl.Sym =  symfun(U,[t Y.' P.']);
%
iCP.AnalyticalControl.Num  = matlabFunction(iCP.AnalyticalControl.Sym,'Vars',{t,Y.',P.'});

  
end

