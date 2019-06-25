function Y = GetNumericalDynamics(iCP,Control)
%GETNUMERICALDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
        iCP.Dynamics.FixedNt = false;
        [~,Y] = solve(iCP.Dynamics,'Control',Control);
end

