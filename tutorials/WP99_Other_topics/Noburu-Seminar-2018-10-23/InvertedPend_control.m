% Design an LQR controller
R = 1; Q = diag([1,1,1,1]);
[ricsol,cleig,K,report] = care(A,B,Q);

f_ctr = @(x) -K*x;

i_linear = @(t,x) A*x + B*f_ctr(x);

tspan = [0,10];
ini =[0,0,0.8,0]; %1.1894299
[time, state] = ode45(i_linear,tspan, ini);

% Physical parameters
m = 0.3;% [kg];
M = 0.8;% [kg];
l = 0.25;% [m];
g = 9.8;% [m/s^2];
i_nonlinear = @(t,x)[x(2);(4*f_ctr(x)-3*g*m*cos(x(3))*sin(x(3))+4*l*m*x(4)^2*sin(x(3)))/(4*M+4*m-3*m*cos(x(3))^2);...
    x(4);-(3*(f_ctr(x)*cos(x(3))-g*m*sin(x(3))-M*g*sin(x(3))+l*m*x(4)^2*cos(x(3))*sin(x(3))))/(l*(4*M+4*m-3*m*cos(x(3))^2))];
[timen, staten] = ode45(i_nonlinear,tspan, ini);

close all
figure(1)
plot(time, state(:,1),'LineWidth',2)
hold on
plot(timen, staten(:,1),'LineWidth',2)
grid on
legend('Linear', 'Nonlinear')
title('Cart position [m]')
hold off


[timen, staten] = ode45(i_nonlinear,tspan, ini);
figure(2)
plot(time, state(:,3),'LineWidth',2)
hold on
plot(timen, staten(:,3),'LineWidth',2)
grid on
legend('Linear', 'Nonlinear')
title('Pndulum angle [rad]')

 