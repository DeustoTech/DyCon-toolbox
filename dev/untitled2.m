 import casadi.*
 x = SX.sym('x',[1 1]);
 v = SX.sym('x',[1 1]);
 u = SX.sym('u',[1 1]);
 t = SX.sym('t');
 mu = 2;
 f = casadi.Function('f',{t,[x;v],u},{ [             v            ; ...
                                           mu*(1-x^2)*v - x + u   ] });
                                       
 T  = 15;
 Nt = 200;
 tspan = linspace(0,T,Nt);
 % Build a ode object
 idyn = ode(f,[x;v],u,tspan);
 SetIntegrator(idyn,'RK8')
 %%
 idyn.InitialCondition = [2,4]'; 
 u0 = ZerosControl(idyn);
 wt = solve(idyn,u0);
 
 %%
 wt = full(wt);
 plot(wt(1,:),wt(2,:),'.-')
 xlabel('v')
 ylabel('x')
 
 %% 
 sigma = @(x) 