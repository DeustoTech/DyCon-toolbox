function distance = TargetDistance(iOCP)
%TARGETDISTANCE Summary of this function goes here
%   Detailed explanation goes here

distance = arrayfun(@(jOCP) sqrt(norm((jOCP.Dynamics.StateVector.Numeric(end,:)' - jOCP.Target).^2)),iOCP);
end

