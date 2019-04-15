function dJ = GetNumericalInitGradient(iCP,Y,P)
%GETNUMERICALINITGRADIENT Summary of this function goes here
%   Detailed explanation goes here
    dx = iCP.dynamics.mesh(2) - iCP.dynamics.mesh(1);
    dJ = dx*P(1,:) +  dx*iCP.gamma*sign(Y(1,:));
end

