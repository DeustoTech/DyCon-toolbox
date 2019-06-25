function [f ,gradf] = bigtoleft(x) 
% This is a simple function that grows rapidly negative 
% as x(1) gets negative 
f=10*x(1)^3+x(1)*x(2)^2+x(3)*(x(1)^2+x(2)^2);  
if nargout > 1     
    gradf=[30*x(1)^2+x(2)^2+2*x(3)*x(1); ...
                2*x(1)*x(2)+2*x(3)*x(2); ...     
                       (x(1)^2+x(2)^2)];  
end
end
