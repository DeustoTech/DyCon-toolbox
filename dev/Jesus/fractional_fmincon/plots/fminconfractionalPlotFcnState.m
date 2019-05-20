function result = fminconfractionalPlotFcnState(p,x,optimvalues,init,varargin)
%FMINCONFRACTIONALPLOTFCN Summary of this function goes here
%   Detailed explanation goes here
        y = x(1:p.Nx*p.Nt); % extract
        y = reshape(y,p.Nx,p.Nt);
        
        surf(y)
        result = false;
end

