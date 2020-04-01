function r = dotprod(iocp,X,Y)
%DOTPROD Summary of this function goes here
%   Detailed explanation goes here

tspan = iocp.DynamicSystem.tspan;

XY = sum(X'*Y);

r = sum(diff(tspan).*(XY(1:end-1) + XY(2:end)))*0.5;


end

