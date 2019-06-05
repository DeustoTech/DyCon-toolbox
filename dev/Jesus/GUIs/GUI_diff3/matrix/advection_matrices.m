function V = advection_matrices(xline,yline,v1,v2)
    n1=length(xline);
    n2=length(yline);
    dx=xline(2)-xline(1);
    dy=yline(2)-yline(1);

    mainy = ones(n2,1);
    mainy = cos(0.5*pi*yline');
    Vtil = (v2/(2*dy))*spdiags([-mainy 0*mainy mainy], -1:1, n2, n2);
    
    % C Periodicas 
    %Vtil(1,end) = -(v2/(2*dy));
    %Vtil(end,1) = (v2/(2*dy));
    
    I = (v1/(2*dx))*speye(n2);
    
    %I(1,end) = -(v1/(2*dx));
    %I(end,1) = -(v1/(2*dx));
    I = (v1/(2*dx))*diag(sin(0.5*pi*xline));
    
    V = blktridiag(Vtil,-I,I,n1);
    
    %V(1:n2,n1*n2-n2+1:end) = V(n2+1:2*n2,1:n2);
    %V(n1*n2-n2+1:end,1:n2) = V(1:n2,n2+1:2*n2);
end
