function Y = GetNumericalDynamics(iCP,Control)
%GETNUMERICALDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
        iCP.Dynamics.InitialCondition = Control';
        [~,Y] = solve(iCP.Dynamics);
end

