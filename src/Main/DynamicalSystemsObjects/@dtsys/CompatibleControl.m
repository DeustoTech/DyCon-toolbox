function CompatibleControl(iode,Control)
%COMPATIBLECONTROL Summary of this function goes here
%   Detailed explanation goes here

[ControlDimension ,Nt] = size(Control);

if ControlDimension ~= iode.ControlDimension || Nt ~= iode.Nt
    error("The Control matrix must be a matrix: ["+iode.ControlDimension +"x"+iode.Nt+"]")
end

