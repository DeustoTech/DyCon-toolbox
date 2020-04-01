function [A,B] = ABmatrixSimu(nu,N)
%ABMATRIXSIMU Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% System matrices A, B
% zdiff = A*z + B*u
% dz/dt = A*z + B*u
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Length of vector nu (number of parameters)
M = length(nu);

Am = eye(N, N);
for i = 1:N
    for j = 1:N
        if j > i
            Am(i, j) = 2;
        end
    end
end
Am = -Am;
%Am(N,N) = -4;
Bm = zeros(N, 1);
Bm(N) = 1;


for j = 1:M
    A{j} = Am + (nu(j) - 1 )*diag(diag(Am));
    B{j} = Bm;
end

A =  blkdiag(A{:});
B =  [B{:}];
B = B(:);

end

