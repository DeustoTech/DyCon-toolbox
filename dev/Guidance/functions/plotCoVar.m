function [xline,yline] = plotCoVar(uem,sigma)    
    
    [V,D] = eig(sigma);
    
    r = -0.5*log(0.1);
    theta = linspace(0,2*pi,100);

    xlinep = (r*sqrt(D(1,1)))*cos(theta);
    ylinep = (r*sqrt(D(2,2)))*sin(theta);

    xy = V*[xlinep;ylinep];
    
    xline = uem(1) + xy(1,:);
    yline = uem(2) + xy(2,:);
end

