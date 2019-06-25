function GetSymbolicalDynamics(obj)
%GETSYMBOLICALDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
    Ysym     = obj.StateVector.Symbolic;
    Usym     = obj.Control.Symbolic;
    tsym     = obj.symt;
    Params   = [obj.Params.sym];    
    obj.DynamicEquation.Sym = obj.DynamicEquation.Num(tsym,Ysym,Usym,Params);
end

