function sum = Riemann(tspan,F)
%RE Summary of this function goes here
%   Detailed explanation goes here

 sum = diff(tspan).*F();
end

