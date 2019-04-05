%% Nonlinear optimal control with time minimization
% The system includes two particles, the driver and the evader. The
% objective of the control is to 'make the evader (ue) passes some point u_f'.

Y = sym('y',[8 1]); % ud = Y(1:2), ue = Y(3:4), vd = Y(5:6), ve = Y(7:8);
U = sym('u',[2 1]);
T = U(2); % Final time by time scaling

Y_rel = [Y(1)-Y(3);Y(2)-Y(4);Y(5)-Y(7);Y(6)-Y(8)];
Y_rel_pos = [Y(1)-Y(3);Y(2)-Y(4)];
Y_rel_norm2 = (Y_rel_pos.'*Y_rel_pos);
  
f_e = @(x) (2./x.^2);
f_d = @(x) -(-5.5./x.^2+10./x.^4-2);
f_e2 = @(x) (2./x);
f_d2 = @(x) -(-5.5./x+10./x.^2-2);
nu_e = 2.0;
nu_d = 2.0;
  
S_1 = [-f_d2(Y_rel_norm2), 0, +f_d2(Y_rel_norm2), 0;
       0, -f_d2(Y_rel_norm2), 0, +f_d2(Y_rel_norm2);
       -f_e2(Y_rel_norm2), 0, +f_e2(Y_rel_norm2), 0;
       0, -f_e2(Y_rel_norm2), 0, +f_e2(Y_rel_norm2)];
   
K_1 = U(1).*[0, -1, 0, 1;
              1, 0, -1, 0;
              0, 0, 0, 0;
              0, 0, 0, 0];

L = [zeros(4), eye(4); S_1+K_1, -diag([nu_d,nu_d,nu_e,nu_e])];
F = L*Y*T;


dt = 0.1;
dynamics = ode(F,Y,U,'FinalTime',1,'dt',dt);
dynamics.InitialCondition = [-3;0;0;0;0;0;0;0]; % ud = (-3,0), ue = (0,0) initially.

% T=5.1725, kappa = 1.5662 -> [-1,1]
tline = dynamics.tspan;
U0_tline = [1.5662*ones(size(tline));5.1725*ones(size(tline))]'; % Initiall guess : Known solution to make ue(T)=u_f.

dynamics.Control.Numeric = U0_tline;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dynamics.Solver=@ode45;
dynamics.SolverParameters={options};
%%
% Test the initial guess
solve(dynamics);
%plot(dynamics)

Y_tline = dynamics.StateVector.Numeric;
figure(1);
plot(Y_tline(:,1),Y_tline(:,2),'b-');
hold on
plot(Y_tline(:,3),Y_tline(:,4),'r-');

j=1;
plot(Y_tline(j,1),Y_tline(j,2),'bs');
plot(Y_tline(j,3),Y_tline(j,4),'rs');

plot(Y_tline(end,1),Y_tline(end,2),'bo');
plot(Y_tline(end,3),Y_tline(end,4),'ro');
plot([-1],[1],'ks','MarkerSize',20)
legend('Driver','Evader','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')

%%
% Cost = 1*|ue-u_f|^2 + 0.1*T + \int_0^T |u(t)|^2dt.
u_e = [Y(3);Y(4)];
u_f = [-1;1];
Psi = 1*(u_e-u_f).'*(u_e-u_f);
L   = 0.001*(U(1).'*U(1)+100)*T;

iP = OptimalControl(dynamics,Psi,L);
%Constraints on the control
%iP.constraints.Umax = 1.7;
%iP.constraints.Umin = -1.7;
%iP.constraints.Projection = @(Utline) [Utline(:,1),mean(Utline(:,end))*ones(size(Utline(:,end)))];
%iP.constraints.Projection = @(Utline) [Utline(:,1),0.5*(Utline(:,end)+abs(Utline(:,end)))];
%Umax = 2; Umin = -2;
%iP.constraints.Projection = @(Utline) [0.5*((0.5*((Utline(:,1) - Umax) - abs(Utline(:,1) - Umax))+Umax-Umin)+abs(0.5*((Utline(:,1) - Umax) - abs(Utline(:,1) - Umax))+Umax-Umin))+Umin,Utline(:,end)];
%%
figure(2);
%GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-3,'Graphs',true,'U0',U0_tline);
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff'},'tol',1e-4,'Graphs',true,'U0',U0_tline);
%GradientMethod(iP,'DescentAlgorithm',@AdaptativeDescent,'DescentParameters',{'StopCriteria','Jdiff'},'tol',1e-4,'Graphs',true,'U0',U0_tline);

temp = iP.solution.UOptimal;
%GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'DirectionParameter','PPR'},'tol',1e-4,'Graphs',true,'U0',temp);

%%
% Visualize the result

UO_tline = iP.solution.UOptimal;
YO_tline = iP.solution.Yhistory(end);
YO_tline = YO_tline{1};
zz = YO_tline;
f1 = figure('position', [0, 0, 1000, 400]);

% Trajectories
subplot(1,2,1)
plot(zz(:,1),zz(:,2),'b-','LineWidth',1.3);
hold on
plot(zz(:,3),zz(:,4),'r-','LineWidth',1.3);
j=1;
plot(zz(j,1),zz(j,2),'bs');
plot(zz(j,3),zz(j,4),'rs');

plot(zz(end,1),zz(end,2),'bo');
plot(zz(end,3),zz(end,4),'ro');
plot([-1],[1],'ks','MarkerSize',20)
legend('Driver','Evader','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')

% Control function
subplot(1,2,2)
tline_UO = dt*cumtrapz(UO_tline(:,end));
plot(tline_UO,UO_tline(:,1),'LineWidth',1.3)
xlim([0 tline_UO(end)])
xlabel('Time')
ylabel('Control \kappa(t)')
legend(['Total Time = ',num2str(tline_UO(end))])




