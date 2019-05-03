function V = advection_matrices(xline,yline,v1,v2)
    n1=length(xline);
    n2=length(yline);
    dx=xline(2)-xline(1);
    dy=yline(2)-yline(1);

    mainy = ones(n2,1);
    mainy = sin(4*pi*yline');

    Vtil = (v2/(2*dy))*spdiags([-mainy 0*mainy mainy], -1:1, n2, n2);
    I = (v1/(2*dx))*speye(n2);

    I = (1/(2*dx))*diag(v1*sin(4*pi*yline));
    
    V = blktridiag(Vtil,-I,I,n1);
end