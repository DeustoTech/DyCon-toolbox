function [xnext,vnext] = rk4_step_2D(f_x,f_v,dt,xms,vms,ams)
%RK4 Summary of this function goes here


   % Euler forward method
   %
   k1x = f_x( xms  , vms   ,ams);
   k1v = f_v( xms  , vms   ,ams);
   %
   k2x = f_x( xms +0.5*k1x*dt ,  vms +0.5*k1v*dt    ,ams);
   k2v = f_v( xms +0.5*k1x*dt ,  vms +0.5*k1v*dt    ,ams);
   %
   k3x = f_x( xms +0.5*k2x*dt ,  vms +0.5*k2v*dt    ,ams);
   k3v = f_v( xms +0.5*k2x*dt ,  vms +0.5*k2v*dt    ,ams);   
    %
   k4x = f_x( xms +1.0*k3x*dt ,  vms +1.0*k3v*dt    ,ams);
   k4v = f_v( xms +1.0*k3x*dt ,  vms +1.0*k3v*dt    ,ams);  
   %
   xnext = xms + (1/6)*dt*(k1x + 2*k2x + 2*k3x + k4x); 
   vnext = vms + (1/6)*dt*(k1v + 2*k2v + 2*k3v + k4v); 

end
