function [tspan,st] = euler(f,tspan,s0)
%EULER Summary of this function goes here
%   Detailed explanation goes here
Nt = length(tspan);
N  = length(s0);
st = zeros(Nt,N);

st(1,:) = s0';
for it = 2:Nt
    dt = tspan(it) - tspan(it-1);
    st(it,:) = st(it-1,:) + dt*f(tspan(it),st(it-1,:)')';
end
end

