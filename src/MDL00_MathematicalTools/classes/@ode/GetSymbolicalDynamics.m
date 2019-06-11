function GetSymbolicalDynamics(obj)
%GETSYMBOLICALDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
    Ysym = obj.StateVector.Symbolic;
    Usym = obj.Control.Symbolic;
    tsym = obj.symt;
    obj.DynamicEquation.Symbolical = obj.DynamicEquation.Numerical(tsym,Ysym,Usym);
end

