function [tline,yline] = eulere(odefun,tspan,y0,options)
    tline = tspan;
    yline = zeros(length(tspan),length(y0));
    yline(1,:) = y0;
    
    for i=1:length(tspan)-1
        vector = odefun(tline(i),yline(i,:)')';
        yline(i+1,:) = yline(i,:) + vector*(tline(i+1)-tline(i));
    end        
end