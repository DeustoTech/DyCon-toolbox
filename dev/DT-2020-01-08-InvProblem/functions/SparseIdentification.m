function U0 = SparseIdentification(u_target,TOL,dt,n,N,M,A,V,epsilon,tau)
% This function computes the adjoint algorithm for sparse source
% identification (algorithm 4 in the paper)

u0=zeros(2*N*N+N,1);

[u0,error] = GradientDescent(u0,u_target,TOL,dt,n,M,A,V,epsilon,tau); % Call to gradient descent algorithm (first step of the algorithm to find the locations of the sources)

u0 = LocalMaxima(u0,N); % find the local maxima of u0 

locs=find(u0);
u0_max = u0(locs);
L = sparse(length(u_target),length(u0_max));
for i=1:length(u0_max) % Build matrix L for least squares
   L(locs(i),i)=1;
   L(:,i) = ForwardSolution(L(:,i),n,dt,M,A,V);
end
intensities=(L'*L)\(L'*u_target); % solve least squares problem to find the intensities of the sources
u0=zeros((2*N+1)*N,1);
for i=1:length(intensities)
    u0(locs(i))=intensities(i); % update u0
end

U0 = zeros(N+2,2*N+3);
U0(2:end-1,2:end-1) = reshape(u0,N,2*N+1);
end