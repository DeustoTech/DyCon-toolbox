%% Nonlinear optimal control with time minimization
% The system includes two particles, the driver and the evader. The
% objective of the control is to 'make the evader (ue) passes some point
% u_f'. 
%% Model
% The dynamics are in two-dimensional space, where 'ud' and 'ue' are
% positions of the driver and evaders, and 'vd' and 've' are velocities of
% them. Then, the dynamics are given by relative interactions,
%%
% $$
% \dot v_d = -f_d(|u_d - u_e|)*(u_d - u_e) - \nu_d v_d + \kappa(t) (u_d -
% u_e)^{\perp},
% $$
%%
% $$
% \dot u_d = -f_e(|u_d - u_e|)*(u_d - u_e) - \nu_e v_e,
% $$
%%
% for some interactions kernels 'f_d' and 'f_e'. We may describe it as
% follows:

syms t;

Y = sym('y',[8 1]); % States vectors for positions and velocities
ud = Y(1:2); ue = Y(3:4); vd = Y(5:6); ve = Y(7:8);

U = sym('u',[2 1]);
kappa = U(1); % Control function of the original problem

ur = ud-ue; % Relative position, driver - evader

f_e2 = @(x) (2./x);
f_d2 = @(x) -(-5.5./x+10./x.^2-2);
nu_e = 2.0;
nu_d = 2.0;

% Dynamics
dot_ud = vd;
dot_ue = ve;
dot_vd = -f_d2(ur.'*ur)*ur - nu_d*vd + kappa * [-ur(2);ur(1)];
dot_ve = -f_e2(ur.'*ur)*ur - nu_e*ve;

%
% The control function is the only argument we can use for minimization.
% For time minimization, we set U(2) as a time variable T(s) for s in
% [0,1]. Therefore, this implies that we use the time-scaling
%
% $$ dt = T(s)ds, $$
%
% from the original equation with t to the equation with s. Then, we need
% to multiply T(s) on the equation, and the final time is calculated by
%
% $$ T_f = \int_0^1 T(s)ds. $$
%
% In this way, we have flexible final time $T_f$ based on non-negative
% function T(s).

T = U(2); % Time-scaling from s to t
F = [dot_ud;dot_ue;dot_vd;dot_ve]*T; % Multiply original velocities with time-scaling T(s).
numF = matlabFunction(F,'Var',{t,Y,U});

Nt = 101; % Numerical time discretization
dt = 1/(Nt-1);
dynamics = ode(numF,Y,U,'FinalTime',1,'Nt',Nt);

% ud = (-3,0), ue = (0,0), and zero velocities initially.
dynamics.InitialCondition = [-3;0;0;0;0;0;0;0]; 

%% Figure 1 : test
% Known solution : T=5.1725, kappa = 1.5662 leads the evader close to uf = [-1;1].
% Initiall guess based on the known solution to make ue(T)=uf.
tline = dynamics.tspan;
T_f = 5.1727;
t2 = 5.1727;
t1 = 0;
U0_tline = [1.5662*ones(size(tline));T_f*ones(size(tline))]'; 
uf = [-1;1];

dynamics.Control.Numeric = U0_tline;

options = odeset('RelTol',1e-7,'AbsTol',1e-7);
dynamics.Solver=@ode45;
dynamics.SolverParameters={options};

% Trajectories from initial guess
% Test the initial guess on the control, 'U0_tline'.
solve(dynamics);

UO_tline = U0_tline;
Y_tline = dynamics.StateVector.Numeric;
zz = Y_tline;

% Cost calcultaion
tline_UO = dt*cumtrapz(UO_tline(:,end));

Final_Time = tline_UO(end);

Final_Position = [zz(end,3);zz(end,4)];
Final_Psi = (Final_Position - uf).'*(Final_Position - uf);

Final_Reg = cumtrapz(tline_UO,UO_tline(:,1).^2);
Final_Reg = Final_Reg(end);

%JO = Final_Psi + 0.1*Final_Time + 0.001*(Final_Reg);
JO = Final_Psi + 0.001*(Final_Reg);

f1 = figure('position', [0, 0, 1000, 330]);

subplot(1,2,1)
hold on
plot(zz(:,1),zz(:,2),'b-','LineWidth',1.3);
plot(zz(:,3),zz(:,4),'r-','LineWidth',1.3);
plot(uf(1),uf(2),'ks','MarkerSize',20)
j=1;
plot(zz(j,1),zz(j,2),'bs');
plot(zz(j,3),zz(j,4),'rs');
% j=ceil(t2/T_f/dt);
% plot(zz(j,1),zz(j,2),'bo');
% plot(zz(j,3),zz(j,4),'ro');
% j=floor(t1/T_f/dt);
% plot(zz(j,1),zz(j,2),'bo');
% plot(zz(j,3),zz(j,4),'ro');

plot(zz(end,1),zz(end,2),'bo');
plot(zz(end,3),zz(end,4),'ro');
hold off
legend('Driver','Evader','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')
%title(['Final position = (', num2str(Final_Position(1)),',',num2str(Final_Position(2)),')'])
title(['Position error = ', num2str(Final_Psi)])

grid on

% Control function
subplot(1,2,2)

plot([0; tline_UO; tline_UO(end)],[0; UO_tline(:,1); 0],'LineWidth',1.3)

grid on

xlim([0 tline_UO(end)])
ylim([-0.5 2])
xlabel('Time')
ylabel('Control \kappa(t)')
legend('Driver')

%title(['Total Time = ',num2str(tline_UO(end))])
title(['Total Time = ',num2str(tline_UO(end)),' and running cost = ',num2str(Final_Reg)])
%title(['Cost = ',num2str(Final_Psi),' + 0.1*',num2str(Final_Time),' + 0.001*',num2str(Final_Reg),' = ',num2str(JO)])


%% Figure : Cost without time minimization
% $$ J = 1*|ue(T)-uf|^2 + 0.001*\int_0^T |u(t)|^2dt. $$

Psi = 1*(ue-uf).'*(ue-uf);
L   = 0.001*((kappa).^2)*T+0.1*T;

numPsi = matlabFunction(Psi,'Var',{t,Y});
numL = matlabFunction(L,'Var',{t,Y,U});

dynamics.Solver=@eulere;
dynamics.SolverParameters={};
iP = Pontryagin(dynamics,numPsi,numL);

%Constraints on the control : Time should be nonnegative
min_dt = 0.1;
iP.Constraints.Projector = @(Utline) [Utline(:,1),0.5*(Utline(:,end)-min_dt+abs(Utline(:,end)-min_dt))+min_dt];
%%
tol = 1e-6;
GradientMethod(iP,U0_tline,'DescentAlgorithm',@ConjugateDescent,'tol',tol,'tolU',tol,'tolJ',tol,'Graphs',true);

temp = iP.Solution.UOptimal;

% %%
% tol = 1e-7;
% GradientMethod(iP,temp,'DescentAlgorithm',@AdaptativeDescent,'tol',tol,'tolU',tol,'tolJ',tol,'Graphs',true);
% 
% temp = iP.Solution.UOptimal;

%% Visualization
% Two importants points in the result:
% 1. The time should be calculated in terms of t, not s.
% 2. We need to know the cost components separately.

UO_tline = iP.Solution.UOptimal;    % Controls
YO_tline = iP.Solution.Yhistory(end);
YO_tline = YO_tline{1};   % Trajectories
JO = iP.Solution.JOptimal;    % Cost
zz = YO_tline;
tline_UO = dt*cumtrapz(UO_tline(:,end)); % timeline based on the values of t, which is the integration of T(s)ds.

f1 = figure('position', [0, 0, 1000, 400]);

% Cost calcultaion
Final_Time = tline_UO(end);

Final_Position = [zz(end,3);zz(end,4)];
Final_Psi = (Final_Position - uf).'*(Final_Position - uf);

Final_Reg = cumtrapz(tline_UO,UO_tline(:,1).^2);
Final_Reg = Final_Reg(end);

% Trajectories
subplot(1,2,1)
hold on
plot(zz(:,1),zz(:,2),'b-','LineWidth',1.3);
plot(zz(:,3),zz(:,4),'r-','LineWidth',1.3);
j=1;
plot(zz(j,1),zz(j,2),'bs');
plot(zz(j,3),zz(j,4),'rs');

j=floor(1/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,3),zz(j,4),'ro');
j=floor(2/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,3),zz(j,4),'ro');

j=floor(3/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,3),zz(j,4),'ro');

j=floor(4/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,3),zz(j,4),'ro');

plot(zz(end,1),zz(end,2),'bo');
plot(zz(end,3),zz(end,4),'ro');
plot(uf(1),uf(2),'ks','MarkerSize',20)
legend('Driver','Evader','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')
%title(['Final position = (', num2str(Final_Position(1)),',',num2str(Final_Position(2)),')'])
title(['Position error = ', num2str(Final_Psi)])
grid on

% Control function
subplot(1,2,2)

plot(tline_UO,UO_tline(:,1),'LineWidth',1.3)
xlim([0 tline_UO(end)])
xlabel('Time')
ylabel('Control \kappa(t)')
%legend(['Total Time = ',num2str(tline_UO(end))])
legend('Driver')
grid on

%title(['Cost = ',num2str(Final_Psi),' + 0.1*',num2str(Final_Time),' + 0.001*',num2str(Final_Reg),' = ',num2str(JO)])
title(['Total Time = ',num2str(tline_UO(end)),' and running cost = ',num2str(Final_Reg)])



