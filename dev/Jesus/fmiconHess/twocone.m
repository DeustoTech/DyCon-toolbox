function [c ceq gradc gradceq] = twocone(x) 
% This constraint is two cones, z > -10 + r 
% and z < 3 - r  
    ceq = [];
    r = sqrt(x(1)^2 + x(2)^2);
    %
    c = [-10+r-x(3);  ...
          x(3)-3+r];
    
      if nargout > 2 
        gradceq = [];     
        gradc = [x(1)/r, x(1)/r;   ...     
                 x(2)/r, x(2)/r;   ... 
                  -1   , 1];
     end
end