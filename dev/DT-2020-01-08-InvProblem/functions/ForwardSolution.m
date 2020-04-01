function u = ForwardSolution(u0,n,dt,M,A,V)
% This function computes the dynamics of the forward problem (corresponds to algorithm 1 in the paper)
u=u0;
for i=1:n 
    u=(M+dt*A+dt*V)\(M*u); % implicit Euler
end
end