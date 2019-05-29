function result = fmpoc(p,x,optimvalues,init)
%FMPOC Summary of this function goes here
%   Detailed explanation goes here


plot(p.dynamics.StateVector.Numeric(end,:))
line(1:length(p.ytarget),p.ytarget,'Color','r')

result = false;

end

