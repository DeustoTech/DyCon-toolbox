function [xline,yline] = xyqua(xf,yf)
%XYQUA Summary of this function goes here
%   Detailed explanation goes here
    a = (-yf + xf.^2)./(2*xf);
    xline = linspace(0,xf,500);
    yline = (xline-a).^2 - a.^2;
    
    yline(yline<yf) = yf;
    
    
end

