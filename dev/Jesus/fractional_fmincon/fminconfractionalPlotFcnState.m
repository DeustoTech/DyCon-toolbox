function result = fminconfractionalPlotFcn(p,x,optimvalues,init,varargin)
%FMINCONFRACTIONALPLOTFCN Summary of this function goes here
%   Detailed explanation goes here
        y = x(1:p.Nx*p.Nt); % extract
        y = reshape(y,p.Nt,p.Nx);
        
        u = x(1+p.Nx*p.Nt:end); % extract
        c = -u;
        u = reshape(u,p.Nt,p.Nu);
        
%         subplot(1,2,1)
%         surf(u)
%         subplot(1,2,2)
        
        surf(y)
        result = false;
end

