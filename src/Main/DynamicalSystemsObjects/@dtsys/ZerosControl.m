function ZeroControl = ZerosControl(isys)
%ZEROCONTROL Summary of this function goes here
%   Detailed explanation goes here
ZeroControl = casadi.DM(isys.ControlDimension,isys.Nt);
end

