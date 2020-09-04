function [A,B] = GenAveParams(nu,N,M)
%GENMATAVE Summary of this function goes here
%   Detailed explanation goes here


Am = eye(N, N);
for i = 1:N
    for j = 1:N
        if j > i
            Am(i, j) = 1;
        end
    end
end
Am = -Am;

Bm = zeros(N, 1);
Bm(N) = 1;

A = zeros(N, N,M);
B = zeros(N, 1,M);
for j = 1:M
    Ainit = N*(j-1)+1;
    Aend  = N*j;
    
    A(:,:,j) = Am + (nu(j) - 1 )*diag(diag(Am));    
    B(:,:,j) = Bm;
end
end

