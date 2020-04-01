function [A1,A2,Agg1,Agg2,M1,M2,Mgg1,Mgg2] = compute_matrices(n,d1,d2)

dx=1/(n+1);

main = ones(n,1);
Atil = spdiags([-main 4*main -main], -1:1, n, n);
Atil_G = spdiags([-(1/2)*main 2*main -(1/2)*main], -1:1, n, n);
Mtil_G = spdiags([-(1/24)*main (5/12)*main -(1/24)*main], -1:1, n, n);
N = spdiags([-(1/12)*main (5/6)*main -(1/12)*main], -1:1, n, n);
N1 = spdiags([(1/4)*main -(1/12)*main], -1:0, n, n);
N2 = spdiags([-(1/12)*main (1/4)*main], 0:1, n, n);
I = speye(n);

A1 = (d1/(dx^2))*blktridiag(Atil,-I,-I,n);
A2 = (d2/(dx^2))*blktridiag(Atil,-I,-I,n);

M1 = blktridiag(N,N1,N2,n);
M2 = blktridiag(N,N1,N2,n);

Agg1 = (d1/(dx^2))*Atil_G;
Agg2 = (d2/(dx^2))*Atil_G;

Mgg1 = Mtil_G;
Mgg2 = Mtil_G;

end