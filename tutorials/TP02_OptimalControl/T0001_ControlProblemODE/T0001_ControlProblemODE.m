clear;
syms t
symY = sym('y',[2 1]);
symU = sym('u');

A = [  -5  1  ; 0  -2 ];
B  = [ 1 1]';
Y0 = [-1 1]';
%
Fsym  = sin(t)*A*symY + B*symU + [symY(1)^2 symY(2)].';
%
iode = ode(Fsym,symY,symU);
iode.Condition = Y0;
%
YT = [ 0  0 ]';
symPsi  = (YT - symY).'*(YT - symY);
symL    = 1e-5*(symU.'*symU);
% 
iCP1 = Pontryagin(iode,symPsi,symL);
%%
% Solve by Gradient method
GradientMethod(iCP1)
plot(iCP1)

