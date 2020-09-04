function [r] = delta(x)
k = 1;
r = -(k*(tanh(k*x).^2 - 1))/2;

end

