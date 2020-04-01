function ds = cartpole_dynamics_params(t,s,u,params,nu)
%CARTPOLE_DYNAMICS Summary of this function goes here
%   Detailed explanation goes here

NM = length(s);

M = length(nu);
N = NM/M;

iter = 0;
%
ds = zeros(size(s),class(s));
%
for inu = nu
    iter = iter +1;
    params.m2 = inu;
    ds((iter-1)*N+1:iter*N) = cartpole_dynamics(t,s((iter-1)*N+1:iter*N),u,params);
end


end

