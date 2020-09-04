function xnext = rk4_step(f,t,dt,x0)
%RK4 Summary of this function goes here


   % Euler forward method
   %
   k1 = f(t         ,  x0              );
   k2 = f(t+0.5*dt  ,  x0+0.5*k1*dt    );
   k3 = f(t+0.5*dt  ,  x0+0.5*k2*dt    );
   k4 = f(t+1.0*dt  ,  x0+1.0*k3*dt    );
   %
   xnext = x0 + (1/6)*dt*(k1 + 2*k2 + 2*k3 + k4); 

end
