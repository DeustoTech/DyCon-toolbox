%Run InvertedPend_model.m first
clc;
rho = 0; 
Q = eye(size(A,1));
S = rho * eye(size(A,1));

%Solve -dX/dt = XA + A'X - X*B*R^{-1}*B'*X +Q, X(T) = S
tspan = [10,0];
iniric = S(:);
i_eqn = @(t,x) -f_dric(x, A, B * B.', Q);
opts = odeset('RelTol',1e-10,'AbsTol',1e-10);
[time, X] = ode45(i_eqn, tspan, iniric, opts);



[m n] = size(X);
XX = mat2cell(X, ones(m,1), n);
fh_reshape = @(x)reshape(x,size(A));
XX = cellfun(fh_reshape,XX,'UniformOutput',false);

[ricsol,cleig,K,report] = care(A,B,Q);
XX{end}-ricsol %Convergence check

%LQ controller
u_lq = @(t,x) -K * x;

%Construct feedback controller using interpolation
gain = zeros(length(X),size(A,1));
for i = 1:length(X)
    gain(i,:) = B.' * reshape(X(i,:),size(A));
end
gain_t = @(t) interp1(time,gain,t);
u_dr = @(t,x) -gain_t(t)*x;


tspan = sort(tspan, 'ascend');
ini =[0,0,0.3,0]; %1.1894299

% Physical parameters
m = 0.3;% [kg];
M = 0.8;% [kg];
l = 0.25;% [m];
g = 9.8;% [m/s^2];

i_linear_dricc = @(t,x) A*x + B*u_dr(t,x);
i_linear_aricc = @(t,x) A*x + B*u_lq(t,x);
[timela, statela] = ode45(i_linear_aricc,tspan, ini);
[timel, statel] = ode45(i_linear_dricc,tspan, ini);
input_aric = -K*statela';
input_dric = -K*statel';

close all
figure(10)
plot(timel, statel(:,3),'LineWidth',2)
grid on
hold on
plot(timela, statela(:,3),'LineWidth',2)
hold off
figure(11)
plot(timel,input_dric)
hold on
plot(timela,input_aric)

%Nonlinear equation with the control using differential riccati
i_nonlinear_dr = @(t,x)[x(2);(4*u_dr(t,x)-3*g*m*cos(x(3))*sin(x(3))+4*l*m*x(4)^2*sin(x(3)))/(4*M+4*m-3*m*cos(x(3))^2);...
    x(4);-(3*(u_dr(t,x)*cos(x(3))-g*m*sin(x(3))-M*g*sin(x(3))+l*m*x(4)^2*cos(x(3))*sin(x(3))))/(l*(4*M+4*m-3*m*cos(x(3))^2))];
[timen_dr, staten_dr] = ode45(i_nonlinear_dr,tspan, ini);

%Nonlinear equation with the control using LQ
i_nonlinear_lq = @(t,x)[x(2);(4*u_lq(t,x)-3*g*m*cos(x(3))*sin(x(3))+4*l*m*x(4)^2*sin(x(3)))/(4*M+4*m-3*m*cos(x(3))^2);...
    x(4);-(3*(u_lq(t,x)*cos(x(3))-g*m*sin(x(3))-M*g*sin(x(3))+l*m*x(4)^2*cos(x(3))*sin(x(3))))/(l*(4*M+4*m-3*m*cos(x(3))^2))];
[timen_lq, staten_lq] = ode45(i_nonlinear_lq,tspan, ini);

figure(1)
plot(timen_dr, staten_dr(:,1),'LineWidth',2)
grid on
hold on
plot(timen_lq, staten_lq(:,1),'LineWidth',2)
grid on
legend('Differential Riccati', 'LQ')
title('Nonlinear simulation / Cart position [m]')
hold off
figure(2)
plot(timen_dr, staten_dr(:,3),'LineWidth',2)
grid on
hold on
plot(timen_lq, staten_lq(:,3),'LineWidth',2,'LineStyle','--')
grid on
legend('Differential Riccati', 'LQ')
title('Nonlinear simulation / Pendulum angle [m]')
hold off

