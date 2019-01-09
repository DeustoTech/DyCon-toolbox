% 
clear
% 1dimensional
dom = [-1 1];

A = [ -1  0  ;
       0 -1 ];
 
B = 1;  

L = chebop(dom(1), dom(2));
L.op = @(x,u) A*x + B*u;
% define the variable 



chebfun(@(x) [x(1), x(2)]',[-1 1]);
u0 = chebfun(@(x) 0,[-1 1]);
