%% GBR_2_multi-agents
clear
clf

%% Figure : modified interactions : Two drivers, Flexible time

Y = sym('y',[12 1]);
U = sym('u',[3 1]);

ud = Y(1:2);  
ue = Y(3:4);
vd = Y(5:6);
ve = Y(7:8);
ud2= Y(9:10);
vd2= Y(11:12);
kappa = U(1:2);
kappa1 = U(1);
kappa2 = U(2);
T = U(end);

ur = ud-ue; 
urperp = [-ur(2);ur(1)];
rr = ur.'*ur;

ur2= ud2-ue;
urperp2 = [-ur2(2);ur2(1)];
rr2= ur2.'*ur2;

%f_e = @(x) (2./x.^2);
%f_d = @(x) -(-5.5./x.^2+10./x.^4-2);
f_e2 = @(x) (2./x);
f_d2 = @(x) -(-5.5./x+10./x.^2-2);

delta0 = 1;
deltau = delta0;

% f_e2 = @(x) 2^4*delta0^6/x^3;
% f_d2 = @(x) 2*delta0^2/x - 6*delta0^6/x^2 + 4;
% psir = @(x) delta0^2/x^2 - delta0^4/x^3;
nu_e = 2.0;
nu_d = 2.0;

dot_ud = vd;
dot_ue = ve;
dot_vd = -f_d2(rr)*ur - nu_e*vd + kappa1*urperp;
dot_ve = (-f_e2(rr)*ur/2 -f_e2(rr2)*ur2/2) - nu_e*ve;
dot_ud2= vd2;
dot_vd2= -f_d2(rr2)*ur2 - nu_e*vd2 + kappa2*urperp2;

F = [dot_ud;dot_ue;dot_vd;dot_ve;dot_ud2;dot_vd2]*T;

% T=5.1725, kappa = 1.5662 -> [-1,1]
dt = 0.01;
dynamics = ode(F,Y,U,'FinalTime',1,'dt',dt);
dynamics.InitialCondition = [-3;0.5;0;0;0;0;0;0;-3;-0.5;0;0];
%dynamics.InitialCondition = [-2;-2;0;0;0;0;0;0;2;-2;0;0];
%dynamics.InitialCondition = [-2;-2;0;0;0;0;0;0;2;-2;0;0];
%dynamics.dt = 0.01;
u_f = [-1;1];
%%
tline = dynamics.tspan;
%U0_tline = 1.5662*ones([length(tline),2]);
%U0_tline = [-0.5*ones([length(tline),1]),0.5*ones([length(tline),1])];
%U0_tline = [-0.5*ones([length(tline),1]),1*ones([length(tline),1])];
U0_tline = [1.5662*ones([length(tline),1]),1.5662*ones([length(tline),1]),5.1725*ones([length(tline),1])];

dynamics.Control.Numeric = U0_tline;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dynamics.Solver=@ode45;
dynamics.SolverParameters={options};
solve(dynamics);
%plot(dynamics)


tline = dynamics.tspan;
Y_tline = dynamics.StateVector.Numeric;

plot(Y_tline(:,1),Y_tline(:,2),'b-');
hold on
plot(Y_tline(:,9),Y_tline(:,10),'k-');

plot(Y_tline(:,3),Y_tline(:,4),'r-');
j=1;
plot(Y_tline(j,1),Y_tline(j,2),'bs');
plot(Y_tline(j,3),Y_tline(j,4),'rs');
plot(Y_tline(j,9),Y_tline(j,10),'ks');

plot(Y_tline(end,1),Y_tline(end,2),'bo');
plot(Y_tline(end,3),Y_tline(end,4),'ro');
plot(Y_tline(end,9),Y_tline(end,10),'ko');
plot([u_f(1)],[u_f(2)],'ks','MarkerSize',20)
legend('Driver','Evader','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')

%%

Psi = 1*(ue-u_f).'*(ue-u_f);
L   = 0.001*(kappa.'*kappa)*T;%+0.000*(Y.'*Y)+00*(Y_e-Y_f).'*(Y_e-Y_f) ;

iP = Pontryagin(dynamics,Psi,L);
%iP.ode.Control.Numeric = ones(51,1);
%iP.constraints.Umax = 1.7;
%iP.constraints.Umin = -1.7;
%%
tline = dynamics.tspan;
%U0_tline = zeros(size(dynamics.Control.Numeric));
U0_tline(1:2,1:length(temp)) = temp';
%%
%U0_tline = 1.5662*ones([length(tline),2]);
%U0_tline = [-0.5*ones([length(tline),1]),0.5*ones([length(tline),1])];
GradientMethod(iP,'DescentAlgorithm',@ConjugateDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-3,'Graphs',true,'U0',U0_tline);


%iP.solution
%plot(iP)
temp = iP.solution.UOptimal;
%%
%temp = temp3;
%temp = try1;
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-6,'Graphs',true,'U0',temp);
%GradientMethod(iP,'DescentAlgorithm',@AdaptativeDescent,'Graphs',true,'U0',temp);
%plot(iP)
temp = iP.solution.UOptimal;
%%
UO_tline = iP.solution.UOptimal;    % Controls
YO_tline = iP.solution.Yhistory(end);
YO_tline = YO_tline{1};   % Trajectories
JO = iP.solution.JOptimal;    % Cost
zz = YO_tline;
tline_UO = dt*cumtrapz(UO_tline(:,end)); % timeline based on the values of t, which is the integration of T(s)ds.
% Cost calcultaion
Final_Time = tline_UO(end);

Final_Position = [zz(end,3);zz(end,4)];
Final_Psi = (Final_Position - u_f).'*(Final_Position - u_f);

Final_Reg = cumtrapz(tline_UO,(UO_tline(:,1).^2+UO_tline(:,2).^2)/2);
Final_Reg = Final_Reg(end);

f1 = figure('position', [0, 0, 1000, 400]);

subplot(1,2,1)
plot(zz(:,1),zz(:,2),'b-','LineWidth',1.3);
hold on
plot(zz(:,3),zz(:,4),'r-','LineWidth',1.3);
plot(zz(:,9),zz(:,10),'k-','LineWidth',1.3);
j=1;
plot(zz(j,1),zz(j,2),'bs');
plot(zz(j,9),zz(j,10),'ks');
plot(zz(j,3),zz(j,4),'rs');

j=floor(1/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,9),zz(j,10),'ko');
plot(zz(j,3),zz(j,4),'ro');

j=floor(2/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,9),zz(j,10),'ko');
plot(zz(j,3),zz(j,4),'ro');

j=floor(3/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,9),zz(j,10),'ko');
plot(zz(j,3),zz(j,4),'ro');

j=floor(4/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,9),zz(j,10),'ko');
plot(zz(j,3),zz(j,4),'ro');

plot(zz(end,1),zz(end,2),'bo');
plot(zz(end,3),zz(end,4),'ro');
plot(zz(end,9),zz(end,10),'ko');
plot([u_f(1)],[u_f(2)],'ks','MarkerSize',20)
legend('Driver1','Evader','Driver2','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')
title(['Position error = ', num2str(Final_Psi)])
grid on

subplot(1,2,2)
tline_UO = dt*cumtrapz(UO_tline(:,end));
plot(tline_UO,UO_tline(:,1:2),'LineWidth',1.3)
xlim([tline_UO(1) tline_UO(end)])
legend('Driver1','Driver2')
xlabel('Time')
ylabel('Control \kappa(t)')
title(['Total Time = ',num2str(tline_UO(end)),' and running cost = ',num2str(Final_Reg)])
grid on









%% Figure : modified interactions : Two drivers, Minimum time

Y = sym('y',[12 1]);
U = sym('u',[3 1]);

ud = Y(1:2);  
ue = Y(3:4);
vd = Y(5:6);
ve = Y(7:8);
ud2= Y(9:10);
vd2= Y(11:12);
kappa = U(1:2);
kappa1 = U(1);
kappa2 = U(2);
T = U(end);

ur = ud-ue; 
urperp = [-ur(2);ur(1)];
rr = ur.'*ur;

ur2= ud2-ue;
urperp2 = [-ur2(2);ur2(1)];
rr2= ur2.'*ur2;

%f_e = @(x) (2./x.^2);
%f_d = @(x) -(-5.5./x.^2+10./x.^4-2);
f_e2 = @(x) (2./x);
f_d2 = @(x) -(-5.5./x+10./x.^2-2);

delta0 = 1;
deltau = delta0;

% f_e2 = @(x) 2^4*delta0^6/x^3;
% f_d2 = @(x) 2*delta0^2/x - 6*delta0^6/x^2 + 4;
% psir = @(x) delta0^2/x^2 - delta0^4/x^3;
nu_e = 2.0;
nu_d = 2.0;

dot_ud = vd;
dot_ue = ve;
dot_vd = -f_d2(rr)*ur - nu_e*vd + kappa1*urperp;
dot_ve = (-f_e2(rr)*ur/2 -f_e2(rr2)*ur2/2) - nu_e*ve;
dot_ud2= vd2;
dot_vd2= -f_d2(rr2)*ur2 - nu_e*vd2 + kappa2*urperp2;

F = [dot_ud;dot_ue;dot_vd;dot_ve;dot_ud2;dot_vd2]*T;

% T=5.1725, kappa = 1.5662 -> [-1,1]
dt = 0.01;
dynamics = ode(F,Y,U,'FinalTime',1,'dt',dt);
dynamics.InitialCondition = [-3;0.5;0;0;0;0;0;0;-3;-0.5;0;0];
%dynamics.InitialCondition = [-2;-2;0;0;0;0;0;0;2;-2;0;0];
%dynamics.InitialCondition = [-2;-2;0;0;0;0;0;0;2;-2;0;0];
%dynamics.dt = 0.01;
u_f = [-1;1];
%%
tline = dynamics.tspan;
%U0_tline = 1.5662*ones([length(tline),2]);
%U0_tline = [-0.5*ones([length(tline),1]),0.5*ones([length(tline),1])];
%U0_tline = [-0.5*ones([length(tline),1]),1*ones([length(tline),1])];
U0_tline = [1.5662*ones([length(tline),1]),1.5662*ones([length(tline),1]),5.1725*ones([length(tline),1])];

dynamics.Control.Numeric = U0_tline;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dynamics.Solver=@ode45;
dynamics.SolverParameters={options};
solve(dynamics);
%plot(dynamics)


tline = dynamics.tspan;
Y_tline = dynamics.StateVector.Numeric;

plot(Y_tline(:,1),Y_tline(:,2),'b-');
hold on
plot(Y_tline(:,9),Y_tline(:,10),'k-');

plot(Y_tline(:,3),Y_tline(:,4),'r-');
j=1;
plot(Y_tline(j,1),Y_tline(j,2),'bs');
plot(Y_tline(j,3),Y_tline(j,4),'rs');
plot(Y_tline(j,9),Y_tline(j,10),'ks');

plot(Y_tline(end,1),Y_tline(end,2),'bo');
plot(Y_tline(end,3),Y_tline(end,4),'ro');
plot(Y_tline(end,9),Y_tline(end,10),'ko');
plot([u_f(1)],[u_f(2)],'ks','MarkerSize',20)
legend('Driver','Evader','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')

%%

Psi = 1*(ue-u_f).'*(ue-u_f);
L   = 0.001*(kappa.'*kappa)*T+0.1*T;%+0.000*(Y.'*Y)+00*(Y_e-Y_f).'*(Y_e-Y_f) ;

iP = Pontryagin(dynamics,Psi,L);
%iP.ode.Control.Numeric = ones(51,1);
%iP.constraints.Umax = 1.7;
%iP.constraints.Umin = -1.7;
%%
tline = dynamics.tspan;
%U0_tline = zeros(size(dynamics.Control.Numeric));
U0_tline(1:2,1:length(temp)) = temp';
%%
%U0_tline = 1.5662*ones([length(tline),2]);
%U0_tline = [-0.5*ones([length(tline),1]),0.5*ones([length(tline),1])];
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-3,'Graphs',true,'U0',U0_tline);


%iP.solution
%plot(iP)
temp = iP.solution.UOptimal;
%%
%temp = temp3;
%temp = try1;
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-5,'Graphs',true,'U0',temp);
%GradientMethod(iP,'DescentAlgorithm',@AdaptativeDescent,'Graphs',true,'U0',temp);
%plot(iP)
temp = iP.solution.UOptimal;
%%
UO_tline = iP.solution.UOptimal;    % Controls
YO_tline = iP.solution.Yhistory(end);
YO_tline = YO_tline{1};   % Trajectories
JO = iP.solution.JOptimal;    % Cost
zz = YO_tline;
tline_UO = dt*cumtrapz(UO_tline(:,end)); % timeline based on the values of t, which is the integration of T(s)ds.
% Cost calcultaion
Final_Time = tline_UO(end);

Final_Position = [zz(end,3);zz(end,4)];
Final_Psi = (Final_Position - u_f).'*(Final_Position - u_f);

Final_Reg = cumtrapz(tline_UO,(UO_tline(:,1).^2+UO_tline(:,2).^2)/2);
Final_Reg = Final_Reg(end);

f1 = figure('position', [0, 0, 1000, 400]);

subplot(1,2,1)
plot(zz(:,1),zz(:,2),'b-','LineWidth',1.3);
hold on
plot(zz(:,3),zz(:,4),'r-','LineWidth',1.3);
plot(zz(:,9),zz(:,10),'k-','LineWidth',1.3);
j=1;
plot(zz(j,1),zz(j,2),'bs');
plot(zz(j,9),zz(j,10),'ks');
plot(zz(j,3),zz(j,4),'rs');

j=floor(1/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,9),zz(j,10),'ko');
plot(zz(j,3),zz(j,4),'ro');

j=floor(2/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,9),zz(j,10),'ko');
plot(zz(j,3),zz(j,4),'ro');

j=floor(3/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,9),zz(j,10),'ko');
plot(zz(j,3),zz(j,4),'ro');

j=floor(4/Final_Time/dt);
plot(zz(j,1),zz(j,2),'bo');
plot(zz(j,9),zz(j,10),'ko');
plot(zz(j,3),zz(j,4),'ro');

plot(zz(end,1),zz(end,2),'bo');
plot(zz(end,3),zz(end,4),'ro');
plot(zz(end,9),zz(end,10),'ko');
plot([u_f(1)],[u_f(2)],'ks','MarkerSize',20)
legend('Driver1','Evader','Driver2','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')
ylim([-2.5 1.5])
title(['Position error = ', num2str(Final_Psi)])
grid on

subplot(1,2,2)
tline_UO = dt*cumtrapz(UO_tline(:,end));
plot(tline_UO,UO_tline(:,1:2),'LineWidth',1.3)
xlim([tline_UO(1) tline_UO(end)])
legend('Driver1','Driver2')
xlabel('Time')
ylabel('Control \kappa(t)')
title(['Total Time = ',num2str(tline_UO(end)),' and running cost = ',num2str(Final_Reg)])
grid on