function dJ = GetNumericalControlGradient(iCP,U,Y,P)
%GETNUMERICALINITGRADIENT Summary of this function goes here
%   Detailed explanation goes here
    dJ = P(1,:) +  iCP.gamma*sign(Y(1,:));
end
