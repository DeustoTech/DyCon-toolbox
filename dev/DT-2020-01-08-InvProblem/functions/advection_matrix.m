function V = advection_matrix(n,v1,v2)

dx=1/(n+1);

main = ones(n,1);
Vtil = v2*spdiags([-main 0*main main], -1:1, n, n);
I = v1*speye(n);

V = (1/(2*dx))*blktridiag(Vtil,-I,I,n);
end