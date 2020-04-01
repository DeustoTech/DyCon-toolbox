 
 import casadi.*
 x = SX.sym('x',[1 1]);
 v = SX.sym('x',[1 1]);
 u = SX.sym('u',[1 1]);
 t = SX.sym('t');
 mu = 1;
 f = casadi.Function('f',{t,[x;v],u},{ [             v            ; ...
                                           mu*(1-x^2)*v - x + u   ] });
% We can define the ode command to build a MATLAB object

 T  = 12;
 Nt = 500;
 tspan = linspace(0,T,Nt);
 % Build a ode object
 idyn = ode(f,[x;v],u,tspan);
 idyn.InitialCondition = [2,4]';
% Solve dynamics with zeros control

 u0 = ZerosControl(idyn);
 wt = solve(idyn,u0);
%%
clf
plot(full(wt(1,:)),full(wt(2,:)),'.-')
hold on
plot(full(wt(1,1)),full(wt(2,1)),'ro')
xlabel('x')
ylabel('v')

