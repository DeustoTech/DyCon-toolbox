function Z = meningitev2( t,y)
%%%%%%%%%%%%%%%%%%we declare  values of constante parameters of models %%%%%%%%%%%%%%%%%%%%%%%%%%
Lambda= 10 ; mu=0.021 ; pi1 = 0.6  ; sigma=0.5 ; rho=0.5;
delta=0.2 ; a=0.6  
 %  Now we compute the function parameter beta   %
tNew= 1:1:13;
W1=[sin(tNew/2/exp(1)*pi)+1]/2
W=interp1(tNew,W1,t,'cubic');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%To comput directly the value of thereshold %%%%%%%
R_0= (W*pi1*Lambda*a)/(mu*(mu+a)*(mu+sigma+rho))

%%%%%%%%%%%%%%% the system %%%%%%%%%%%%%%%%%%%%%%%%%
Z(1) =Lambda + delta*y(4)-(mu*y(1) + W*y(1)* y(3));
Z(2)= W*y(1)* y(3)- (mu + a)*y(2);
Z(3) = pi1*a *y(2)-(mu+sigma+rho)*y(3);
Z(4) =  rho*y(3)+(1-pi1)*a*y(2)-( delta+mu)*y(4);
Z= [Z(1) Z(2) Z(3) Z(4)]'; 
% we are goind to create another matlab file val_meningitev2  
end
