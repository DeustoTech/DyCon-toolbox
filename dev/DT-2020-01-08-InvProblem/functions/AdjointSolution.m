function rho = AdjointSolution(rho,n,dt,M,A,V)
% This function computes the dynamics of the adjoint problem (corresponds to algorithm 2 in the paper)

for i=1:n 
   rho=(M+dt*A-dt*V)\(M*rho);  % implicit Euler
end
end