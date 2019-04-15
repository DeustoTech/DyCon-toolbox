%% Two drivers, Flexible time

Y = sym('y',[16 1]); %[ue1,ue2,ud1,ud2,ve1,ve2,vd1,vd2]
U = sym('u',[3 1]);

ue1= Y(1:2);
ue2= Y(3:4);
ud1= Y(5:6);
ud2= Y(7:8);
ve1= Y(9:10);
ve2= Y(11:12);
vd1= Y(13:14);
vd2= Y(15:16);

uebar = (ue1+ue2)/2;
kappa = U(1:2);
kappa1 = U(1);
kappa2 = U(2);
T = U(3);

perp = @(u) [-u(2);u(1)];
square = @(u) u.'*u;

f_e = @(x) (2./x.^2);
f_d = @(x) -(-5.5./x.^2+10./x.^4-2);
f_e2 = @(x) (2./x);
f_d2 = @(x) -(-5.5./x+10./x.^2-2);
nu_e = 2.0;
nu_d = 2.0;

dot_ud1 = vd1;
dot_ud2 = vd2;
dot_ue1 = ve1;
dot_ue2 = ve2;

dot_vd1 = -f_d2(square(ud1-uebar))*(ud1-uebar) - nu_d*vd1 + kappa1*perp(ud1-uebar);
dot_vd2 = -f_d2(square(ud2-uebar))*(ud2-uebar) - nu_d*vd2 + kappa2*perp(ud2-uebar);

dot_ve1 = -f_e2(square(ud1-ue1))*(ud1-ue1) -f_e2(square(ud2-ue1))*(ud2-ue1) - nu_e*ve1;
dot_ve2 = -f_e2(square(ud1-ue2))*(ud1-ue2) -f_e2(square(ud2-ue2))*(ud2-ue2) - nu_e*ve2;

%[dot_ue1;dot_ue2;dot_ud1;dot_ud2;dot_ve1;dot_ve2;dot_vd1;dot_vd2]
F = [dot_ue1;dot_ue2;dot_ud1;dot_ud2;dot_ve1;dot_ve2;dot_vd1;dot_vd2]*T;
Y0= [-2;-0.5; -2;0.5; -4;-3; -4;3; 0;0; 0;0; 0;0; 0;0;];

% T=5.1725, kappa = 1.5662 -> [-1,1]
dt = 0.01;
dynamics = ode(F,Y,U,'FinalTime',1,'dt',dt);
dynamics.InitialCondition = Y0;
%%
tline = dynamics.tspan;
U0_tline = [0.5*ones([length(tline),1]),-0.5*ones([length(tline),1]),4.5*ones([length(tline),1])];
%U0_tline = [UO_tline,1*ones([length(tline),1])];
u_f = [2;0];

dynamics.Control.Numeric = U0_tline;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dynamics.Solver=@ode45;
dynamics.SolverParameters={options};
solve(dynamics);
%plot(dynamics)


tline = dynamics.tspan;
Y_tline = dynamics.StateVector.Numeric;

figure(1);
hold on
plot(Y_tline(:,1),Y_tline(:,2),'r-');
plot(Y_tline(:,3),Y_tline(:,4),'r-');
plot(Y_tline(:,5),Y_tline(:,6),'b-');
plot(Y_tline(:,7),Y_tline(:,8),'b-');

j=1;
plot(Y_tline(j,1),Y_tline(j,2),'rs');
plot(Y_tline(j,3),Y_tline(j,4),'rs');
plot(Y_tline(j,5),Y_tline(j,6),'bs');
plot(Y_tline(j,7),Y_tline(j,8),'bs');

j=floor(length(tline)/5);
plot(Y_tline(j,1),Y_tline(j,2),'ro');
plot(Y_tline(j,3),Y_tline(j,4),'ro');
plot(Y_tline(j,5),Y_tline(j,6),'bo');
plot(Y_tline(j,7),Y_tline(j,8),'bo');

j=length(tline);
plot(Y_tline(j,1),Y_tline(j,2),'ro');
plot(Y_tline(j,3),Y_tline(j,4),'ro');
plot(Y_tline(j,5),Y_tline(j,6),'bo');
plot(Y_tline(j,7),Y_tline(j,8),'bo');

plot([u_f(1)],[u_f(2)],'ks','MarkerSize',20)

%%

Psi = (ue1-u_f).'*(ue1-u_f)+(ue2-u_f).'*(ue2-u_f);
L   = 0.001*(kappa.'*kappa)*T;%+0.000*(Y.'*Y)+00*(Y_e-Y_f).'*(Y_e-Y_f) ;

iP = Pontryagin(dynamics,Psi,L);
%iP.ode.Control.Numeric = ones(51,1);
%iP.constraints.Umax = 1.7;
%iP.constraints.Umin = -1.7;
%%
tline = dynamics.tspan;
temp = interp1(tline1,temp1,tline);
%%
%U0_tline = 1.5662*ones([length(tline),2]);
%U0_tline = [-0.5*ones([length(tline),1]),0.5*ones([length(tline),1])];
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-7,'Graphs',true,'U0',U0_tline);

%iP.solution
%plot(iP)
temp = iP.solution.UOptimal;
%%
%temp = temp3;
%temp = try1;
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'DirectionParameter','PPR'},'tol',1e-10,'Graphs',true,'U0',temp);
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

Final_Position1 = [zz(end,1);zz(end,2)];
Final_Position2 = [zz(end,1);zz(end,2)];
Final_Psi = (Final_Position1 - u_f).'*(Final_Position1 - u_f)+(Final_Position2 - u_f).'*(Final_Position2 - u_f);
Final_Psi = Final_Psi/2;

Final_Reg = cumtrapz(tline_UO,(UO_tline(:,1).^2+UO_tline(:,2).^2)/2);
Final_Reg = Final_Reg(end);

f1 = figure('position', [0, 0, 1000, 400]);

subplot(1,2,1)
hold on
plot(zz(:,1),zz(:,2),'r-','LineWidth',1.3);
plot(zz(:,3),zz(:,4),'r-','LineWidth',1.3);
plot(zz(:,5),zz(:,6),'b-','LineWidth',1.0);
plot(zz(:,7),zz(:,8),'b-','LineWidth',1.0);
j=1;
plot(zz(j,1),zz(j,2),'rs');
plot(zz(j,3),zz(j,4),'rs');
plot(zz(j,5),zz(j,6),'bs');
plot(zz(j,7),zz(j,8),'bs');

j=floor(1/Final_Time/dt);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');

j=floor(2/Final_Time/dt);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');

j=floor(3/Final_Time/dt);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');

j=floor(4/Final_Time/dt);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');

j=length(tline);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');
plot([u_f(1)],[u_f(2)],'ks','MarkerSize',20)
legend('Evader1','Evader2','Driver1','Driver2','Location','northeast')
xlabel('abscissa')
ylabel('ordinate')
%ylim([-2.5 1.5])
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









%% figure : Minimizing Time

Psi = (ue1-u_f).'*(ue1-u_f)+(ue2-u_f).'*(ue2-u_f);
L   = 0.001*(kappa.'*kappa)*T+0.1*T;%+0.000*(Y.'*Y)+00*(Y_e-Y_f).'*(Y_e-Y_f) ;

iP = Pontryagin(dynamics,Psi,L);
%iP.ode.Control.Numeric = ones(51,1);
%iP.constraints.Umax = 1.7;
%iP.constraints.Umin = -1.7;
%%
tline = dynamics.tspan;
temp = interp1(tline1,temp1,tline);
%%
%U0_tline = 1.5662*ones([length(tline),2]);
%U0_tline = [-0.5*ones([length(tline),1]),0.5*ones([length(tline),1])];
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-7,'Graphs',true,'U0',U0_tline);

%iP.solution
%plot(iP)
temp = iP.solution.UOptimal;
%%
%temp = temp3;
%temp = try1;
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-10,'Graphs',true,'U0',temp);
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

Final_Position1 = [zz(end,1);zz(end,2)];
Final_Position2 = [zz(end,1);zz(end,2)];
Final_Psi = (Final_Position1 - u_f).'*(Final_Position1 - u_f)+(Final_Position2 - u_f).'*(Final_Position2 - u_f);
Final_Psi = Final_Psi/2;

Final_Reg = cumtrapz(tline_UO,(UO_tline(:,1).^2+UO_tline(:,2).^2)/2);
Final_Reg = Final_Reg(end);

f1 = figure('position', [0, 0, 1000, 400]);

subplot(1,2,1)
hold on
plot(zz(:,1),zz(:,2),'r-','LineWidth',1.3);
plot(zz(:,3),zz(:,4),'r-','LineWidth',1.3);
plot(zz(:,5),zz(:,6),'b-','LineWidth',1.0);
plot(zz(:,7),zz(:,8),'b-','LineWidth',1.0);
j=1;
plot(zz(j,1),zz(j,2),'rs');
plot(zz(j,3),zz(j,4),'rs');
plot(zz(j,5),zz(j,6),'bs');
plot(zz(j,7),zz(j,8),'bs');

j=floor(1/Final_Time/dt);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');

j=floor(2/Final_Time/dt);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');

j=floor(3/Final_Time/dt);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');

j=floor(4/Final_Time/dt);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');

j=length(tline);
plot(zz(j,1),zz(j,2),'ro');
plot(zz(j,3),zz(j,4),'ro');
plot(zz(j,5),zz(j,6),'bo');
plot(zz(j,7),zz(j,8),'bo');
plot([u_f(1)],[u_f(2)],'ks','MarkerSize',20)
legend('Evader1','Evader2','Driver1','Driver2','Location','northeast')
xlabel('abscissa')
ylabel('ordinate')
%ylim([-2.5 1.5])
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