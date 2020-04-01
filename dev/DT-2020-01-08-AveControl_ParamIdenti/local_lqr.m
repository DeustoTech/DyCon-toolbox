function afeedback = local_lqr(t,s,params)
%LOCAL_LQR Summary of this function goes here
%   Detailed explanation goes here

persistent data 
syms x_ms v_ms theta_ms omega_ms theta2_ms omega2_ms u_ms
state = [x_ms theta_ms theta2_ms v_ms omega_ms omega2_ms].';

fsym = cartpole_dynamics(0,state,u_ms,params);

jac_fsym_x = jacobian(fsym,state);
jac_fsym_u = jacobian(fsym,u_ms);
%
A = double(subs(jac_fsym_x,state,[0 0 0 0 0 0]'));
B = double(subs(jac_fsym_u,state,[0 0 0 0 0 0]'));
%%
[K,~,~] = lqr(A,B,diag([1 1 1 1 1 1]),beta);
afeedback = @(t,s) -K*s; 


end

