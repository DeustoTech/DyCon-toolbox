function [M,A,V] = merge_matrices_2d(A1,A2,Agg1,Agg2,M1,M2,Mgg1,Mgg2,V1,V2)

[n,n]=size(Agg1);

A = sparse(2*n^2+n,2*n^2+n);

A(1:n*n,1:n*n) = A1;
A(n*n+1:n*n+n,n*n+1:n*n+n) = Agg1 + Agg2;
A(n*n+n+1:end,n*n+n+1:end) = A2;
A(n*n+1:n*n+n,n*n-n+1:n*n) = A1(1:n,n+1:2*n);
A(n*n-n+1:n*n,n*n+1:n*n+n) = A1(1:n,n+1:2*n);
A(n*n+n+1:n*n+2*n,n*n+1:n*n+n) = A2(1:n,n+1:2*n);
A(n*n+1:n*n+n,n*n+n+1:n*n+2*n) = A2(1:n,n+1:2*n);

M = sparse(2*n^2+n,2*n^2+n);

M(1:n*n,1:n*n) = M1;
M(n*n+1:n*n+n,n*n+1:n*n+n) = Mgg1 + Mgg2;
M(n*n+n+1:end,n*n+n+1:end) = M2;
M(n*n+1:n*n+n,n*n-n+1:n*n) = M1(1:n,n+1:2*n);
M(n*n-n+1:n*n,n*n+1:n*n+n) = M1(1:n,n+1:2*n);
M(n*n+n+1:n*n+2*n,n*n+1:n*n+n) = M2(1:n,n+1:2*n);
M(n*n+1:n*n+n,n*n+n+1:n*n+2*n) = M2(1:n,n+1:2*n);

V = sparse(2*n^2+n,2*n^2+n);

V(1:n*n,1:n*n) = V1;
V(n*n+1:n*n+n,n*n+1:n*n+n) = V1(1:n,1:n)./2 + V2(1:n,1:n)./2;
V(n*n+n+1:end,n*n+n+1:end) = V2;
V(n*n+1:n*n+n,n*n-n+1:n*n) = V1(n+1:2*n,1:n);
V(n*n-n+1:n*n,n*n+1:n*n+n) = V1(1:n,n+1:2*n);
V(n*n+n+1:n*n+2*n,n*n+1:n*n+n) = V2(n+1:2*n,1:n);
V(n*n+1:n*n+n,n*n+n+1:n*n+2*n) = V2(1:n,n+1:2*n);

end