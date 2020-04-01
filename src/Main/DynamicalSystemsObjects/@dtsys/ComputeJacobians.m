function  ComputeJacobians(idtsys)
%COMPUTEDERIVATIVES Summary of this function goes here
%   Detailed explanation goes here

ts = casadi.SX.sym('t');
Xs = idtsys.State.sym;
Us = idtsys.Control.sym;
 
idtsys.Jacobians.Control = casadi.Function('Fu', {ts,Xs,Us},{jacobian(idtsys.DynamicFcn(ts,Xs,Us),Us)});
idtsys.Jacobians.State   = casadi.Function('Fx', {ts,Xs,Us},{jacobian(idtsys.DynamicFcn(ts,Xs,Us),Xs)});


end

