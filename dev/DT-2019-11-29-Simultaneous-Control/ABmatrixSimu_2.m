function [A,B] = ABmatrixSimu_2(nu,N)
%ABMATRIXSIMU Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% System matrices A, B
% zdiff = A*z + B*u
% dz/dt = A*z + B*u
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Length of vector nu (number of parameters)
M = length(nu);

Am = zeros(N, N);
for i = 1:N-1
    Am(i,i+1) = 1;
end
Bm = zeros(N, 1);
Bm(N) = 1;


for j = 1:M
    Am(N,1) = -nu(j);
    A{j} = Am;
    B{j} = Bm;
end

A =  blkdiag(A{:});
B =  [B{:}];
B = B(:);

end

