function result = fminconfractionalPlotFcnFinal(p,x,optimvalues,init,varargin)
%FMINCONFRACTIONALPLOTFCN Summary of this function goes here
%   Detailed explanation goes here
        y = x(1:p.Nx*p.Nt); % extract

        y = reshape(y,p.Nx,p.Nt);
        
        plot([y(:,end) p.yf])
        legend({'Estimation','Fixed'})

        result = false;
        
end

