function [U_target,u_target] = compute_target(U0_ref,N,n,dt,M,A,V)
% Compute final state from the reference initial solution = target function

ref=zeros(2*N*N+N,1);
ref=reshape(U0_ref(2:end-1,2:end-1),2*N*N+N,1);

u_target=ref;
for i=1:n
    u_target=(M+dt*A+dt*V)\(M*u_target); % implicit Euler
end

U_target = zeros(N+2,2*N+3);
U_target(2:end-1,2:end-1) = reshape(u_target,N,2*N+1);
end