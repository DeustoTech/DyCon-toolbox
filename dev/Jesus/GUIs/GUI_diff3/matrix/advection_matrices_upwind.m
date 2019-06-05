function V = advection_matrices_upwind(xline,yline,v1,v2)
n1=length(xline);
n2=length(yline);
dx=xline(2)-xline(1);
dy=yline(2)-yline(1);

mainy = (- v1/dx - v2/dy)*ones(n2,1);
supdiag = (v2/dy)*ones(n2,1);
Vtil = spdiags([mainy supdiag], 0:1, n2, n2);
Vtil(end,1) = Vtil(1,2);

I = (v1/dx)*speye(n2);

V = blktridiag(Vtil,0*I,I,n1);

V(n1*n2-n2+1:end,1:n2) = V(1:n2,n2+1:2*n2);
end
