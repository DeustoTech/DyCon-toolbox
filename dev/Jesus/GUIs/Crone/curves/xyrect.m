function [xline,yline] = xyrect(xf,yf)

    xi = 0;
    yi = 0;
    %
    xline = linspace(xi,xf,200);
    yline = (-yf+yi)/(-xf+xi)*(xline-xf) + yf;
    
end

