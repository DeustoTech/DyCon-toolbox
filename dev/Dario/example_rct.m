
A = [ 2 -1; ...
     -1  2];
 
 B = [1;0];
 
x0 = [1.4 ;1.4];

 dynamics = ode('A',A,'B',B);
 dynamics.InitialCondition = x0;
 
 LQRfun = LQR(dynamics);
 
 LQRfun.FunctionalParams.C = eye(2);
 LQRfun.FunctionalParams.D = zeros(2,2);
 
 LQRfun.FunctionalParams.beta = 26;
 LQRfun.FunctionalParams.gamma = 0;
 
 

 
 LQRfun.FunctionalParams.q = @(t) [0];
 LQRfun.FunctionalParams.z = @(t) [sin(t);sin(t)];
 
 [ uopt, x] = lqtarget(LQRfun);