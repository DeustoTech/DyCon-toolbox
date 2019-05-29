function result = fminconfractionalPlotFcnInitial(p,x,optimvalues,init,varargin)
%FMINCONFRACTIONALPLOTFCN Summary of this function goes here
%   Detailed explanation goes here

        
        y = x(1:p.Nx*p.Nt); % extract

        y = reshape(y,p.Nx,p.Nt);
        
        plot([y(:,1) p.y0])
        legend({'Estimation','Fixed'})
        result = false;
end

