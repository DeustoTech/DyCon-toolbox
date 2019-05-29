function result = fminconfractionalPlotFcnControl(p,x,optimvalues,init,varargin)
%FMINCONFRACTIONALPLOTFCN Summary of this function goes here
%   Detailed explanation goes here

        if init
           title('Control') 
        end
        u = x(1+p.Nx*p.Nt:p.Nx*p.Nt+p.Nu*p.Nt); % extract
        u = reshape(u,p.Nu,p.Nt);
        
        
        surf(p.B*u)
        result = false;
end

