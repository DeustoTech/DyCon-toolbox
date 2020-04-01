function [u0,error] = GradientDescent(u0,u_target,TOL,dt,n,M,A,V,epsilon,tau)
% This functions computes the gradient descent method by adjoint
% methodology (this corresponds to algorithm 3 in the paper)

error=10; 
k=1;
while(error(k)>TOL) % stopping criteria
    u = ForwardSolution(u0,n,dt,M,A,V); % forward problem
    rho = AdjointSolution(u-u_target,n,dt,M,A,V); % adjoint problem
    u0 = u0-epsilon*(rho + tau*sign(u0)); % update guess for u0
    u0(u0<0) = 0; % denoise the current solution
    error = [error norm(u-u_target)]; % save the error
    k=k+1;
    if (k>1000)
        break;
    end
end
end