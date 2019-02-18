%%
% In this example, we solve the class 'ode' using various numerical
% methods. Here, we solve an oscillating system of differential equations:
%%
% $$ 
% \begin{bmatrix} 
%     \dot{y}_1 \\
%     \dot{y}_2 
%    \end{bmatrix} =
%     \left( \begin{array}{cc}
%             -5 & -10 \\
%             10 & 0      
%            \end{array} \right)
%     \begin{bmatrix}
%          \dot{y}_1 \\ \dot{y}_2
%     \end{bmatrix} 
% $$
%%
% $$ y_1(1) = 1, / / y_2(2) = 2 $$
%%
% We may use a linear input to creat an 'ode' class:
%%
% $$ \dot Y = AY + BU.

A = [ -5 -10 ; 10 0];
B = [1 ; 1];

dynamics_linear = ode('A',A,'B',B);
dynamics_linear.Condition = [1,2];
solve(dynamics_linear)
plot(dynamics_linear)
%%
% 'ode' class contains the time-descrization information, but be careful:
% It does not affact the 'ode45' function which takes adaptive time method.
% They produce basically the same graph, and the tolerance of 'ode45' is
% fixed for any time-descritization. 

dt = 0.01;
dynamics_linear_fine = ode('A',A,'B',B,'dt',dt);
dynamics_linear_fine.Condition = [1,2];
solve(dynamics_linear_fine)
Y_ode45 = dynamics_linear_fine.VectorState.Numeric;
T_ode45 = dynamics_linear_fine.tspan;
plot(dynamics_linear_fine)
hold on
Y_default = dynamics_linear.VectorState.Numeric;
T_default = dynamics_linear.tspan;
plot(T_default,Y_default,'*')
hold off
legend('Y_1','Y_2','Y_1','Y_2')

%%
% 'VectorState.Numeric' and 'tspan' are manual methods to get the results
% of 'solve' function. Note that the values coincide though we gave them
% different time-steps.
%% 
% In the (MATLAB built-in) 'ode45' function, we may give a (MATLAB built-in)
% 'odeset' class to set the parameters.

odefun = @(t,y) A*y;
tspan = 0:dt:1;
y0 = [1,2];

options = odeset('RelTol',1e-5,'AbsTol',1e-5);
[t,y] = ode45(odefun,tspan,y0,options);
plot(t,y-Y_ode45)
xlabel('time(s)')
ylabel('difference of states')
title('Difference of solution with different tolerances')
legend('Y_1','Y_2')

%%
% We may implement the 'options' feature on the 'ode' class, using the
% structure parameter 'RKParameters' of 'ode' class:

dynamics_linear_fine.RKParameters = {options};
solve(dynamics_linear_fine)
Y_new = dynamics_linear_fine.VectorState.Numeric;
T_new = dynamics_linear_fine.tspan;
plot(T_new,Y_new-y)
xlabel('time(s)')
ylabel('difference of states')
title('Difference of solutions with different classes')
legend('Y_1','Y_2')

%%
% Note that the difference of solutions are tiny since they use basically
% the same numerical methods.
%%
% We can use other built-in functions, such as 'ode23'.
dynamics_linear_23 = ode('A',A,'B',B,'dt',dt);
dynamics_linear_23.Condition = [1,2];
dynamics_linear_23.RKMethod = @ode23;
solve(dynamics_linear_23)
Y_ode23 = dynamics_linear_fine.VectorState.Numeric;
T_ode23 = dynamics_linear_fine.tspan;
hold on
plot(T_ode23,Y_ode23-Y_ode45)
xlabel('time(s)')
ylabel('difference of states')
title('Difference of solutions with different solvers')
legend('Y_1','Y_2')

%%
% In the same way, we may implement a customized function. Here, we may
% define the first-order Euler method and use it for solving 'ode' classes.

dynamics_linear_Euler = ode('A',A,'B',B,'dt',dt);
dynamics_linear_Euler.Condition = [1,2];
dynamics_linear_Euler.RKMethod = @Euler;
solve(dynamics_linear_Euler)
plot(dynamics_linear_Euler)
%%
function [tline,yline] = Euler(odefun,tspan,y0,options)
    tline = tspan;
    yline = zeros(length(tspan),length(y0));
    yline(1,:) = y0;
    
    for i=1:length(tspan)-1
        vector = odefun(tline(i),yline(i,:)')';
        yline(i+1,:) = yline(i,:) + vector*(tline(i+1)-tline(i));
    end        
end


