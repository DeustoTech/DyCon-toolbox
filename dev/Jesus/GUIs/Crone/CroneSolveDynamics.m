function [xline,yline,tline] = CroneSolveDynamics(xline,yline,xf,yf)
%CRONESOLVEDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
g = 9.8;

y = @(x) interp1(xline,yline,x);
%
yxline =  gradient(y(xline),xline);
yx = @(x) interp1(xline,yxline,x);
%
xline = linspace(0.01,xf,800);
%
dtdx = @(x,t) sqrt(1+yx(x)^2)/sqrt(-2*g*y(x));
[xline,tline] = ode45(dtdx,xline,0);

%%
yline = y(xline);
%%
end

