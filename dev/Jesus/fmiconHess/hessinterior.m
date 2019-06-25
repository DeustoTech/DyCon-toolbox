function h = hessinterior(x,lambda)  
    h = [60*x(1)+2*x(3)     ,2*x(2)         ,2*x(1); ...
          2*x(2)            ,2*(x(1)+x(3))  ,2*x(2); ...
          2*x(1)            ,2*x(2)         ,0];
% Hessian of f 
r = sqrt(x(1)^2+x(2)^2);
% radius 
rinv3 = 1/r^3; 
hessc = [(x(2))^2*rinv3   , -x(1)*x(2)*rinv3,  0;  ...
         -x(1)*x(2)*rinv3 ,  x(1)^2*rinv3,     0;    ...
         0                ,     0 ,            0];
% Hessian of both c(1) and c(2) 
h = h + lambda.ineqnonlin(1)*hessc + lambda.ineqnonlin(2)*hessc;
end