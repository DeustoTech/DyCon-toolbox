function Y = GetNumericalDynamics(iCP,Control)
%GETNUMERICALDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
        [~,Y] = solve(iCP.Dynamics,'Control',Control);
end

