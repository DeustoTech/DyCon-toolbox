%%
% We plot the optimal trajectory determined by AMPL-IPOpt.

%% STEP 1. We read the data from output file.

fid = fopen('outdata_rotorbalance.txt','r');            % Open out.txt
cost = fscanf(fid,'%s',3);         % Read ``# cost =''
cost = fscanf(fid,'%f',1);               % Read value of cost
T = fscanf(fid,'%s',3);         % Read ``# T =''
T = fscanf(fid,'%d',1);               % Read value of T
Nt = fscanf(fid,'%s',3);         % Read ``# Nt =''
Nt = fscanf(fid,'%d',1);               % Read value of Nt
s  = fscanf(fid,'%s',2); s=[];      % Read ``# Data''
alpha1 = fscanf(fid,'%f',Nt+1); alpha1 = alpha1.';  % Read the (Nt+1) values of alpha1
gamma1 = fscanf(fid,'%f',Nt+1); gamma1 = gamma1.';  % Read the (Nt+1) values of gamma1
alpha2 = fscanf(fid,'%f',Nt+1); alpha2 = alpha2.';  % Read the (Nt+1) values of alpha2
gamma2 = fscanf(fid,'%f',Nt+1); gamma2 = gamma2.';  % Read the (Nt+1) values of gamma2
fclose(fid);                          % Close out.txt

%% STEP 2. We compute the force imbalance+balance in each balancing plane
% and the imbalance indicator along determined trajectory.

% physical parameters.
m1 = 1;
m2 = 1;
a = 1;
b = 1;
r1 = 1;
r2 = 1;
omega = 2000*(2*pi)/60;
Fx = -2*m1*r1*omega^2;
Fy = -2*m2*r2*omega^2;
Nx = 0;
Ny = 0;
F1x = (b*Fx-Ny)/(a+b);
F1y = (b*Fy+Nx)/(a+b);
F2x = (a*Fx+Ny)/(a+b);
F2y = (a*Fy-Nx)/(a+b);
%WARNING:
%The condition below must be fulfilled.
%m_1r_1 > \frac{\sqrt{F_{1,x}^2+F_{1,y}^2}}{2\omega^2}\hspace{0.3 cm}\mbox{and}\hspace{0.3 cm}m_2r_2> \frac{\sqrt{F_{2,x}^2+F_{2,y}^2}}{2\omega^2},

G =zeros(Nt,1); % Imbalance indicator.

for i=1:Nt+1
    G(i) =  (2*m1*r1*omega^2*cos(gamma1(i))*cos(alpha1(i))+F1x)^2 ...
           +(2*m1*r1*omega^2*cos(gamma1(i))*sin(alpha1(i))+F1y)^2 ...
           +(2*m2*r2*omega^2*cos(gamma2(i))*cos(alpha2(i))+F2x)^2 ...
           +(2*m2*r2*omega^2*cos(gamma2(i))*sin(alpha2(i))+F2y)^2;
end

Control = 0;
% force on the balancing plane located at z = -a.
F1totxfixed = @(t)Control*2*m1*r1*omega^2*cos( interp1(linspace(0,T,Nt+1), gamma1, t))*cos( interp1(linspace(0,T,Nt+1), alpha1, t))+F1x; % rotor-fixed reference frame. x-comp of the total force exerted at left end of the axle.
F1totyfixed = @(t)Control*2*m1*r1*omega^2*cos( interp1(linspace(0,T,Nt+1), gamma1, t))*sin( interp1(linspace(0,T,Nt+1), alpha1, t))+F1y; % rotor-fixed reference frame. y-comp of the total force exerted at left end of the axle.

F1totx = @(t)cos(omega*t)*F1totxfixed(t)-sin(omega*t)*F1totyfixed(t); % x-comp of the total force exerted at left end of the axle.
F1toty = @(t)sin(omega*t)*F1totxfixed(t)+cos(omega*t)*F1totyfixed(t); % y-comp of the total force exerted at left end of the axle.

% force on the balancing plane located at z = b.
F2totxfixed = @(t)Control*2*m2*r2*omega^2*cos( interp1(linspace(0,T,Nt+1), gamma2, t))*cos( interp1(linspace(0,T,Nt+1), alpha2, t))+F2x; % rotor-fixed reference frame. x-comp of the total force exerted at left end of the axle.
F2totyfixed = @(t)Control*2*m2*r2*omega^2*cos( interp1(linspace(0,T,Nt+1), gamma2, t))*sin( interp1(linspace(0,T,Nt+1), alpha2, t))+F2y; % rotor-fixed reference frame. y-comp of the total force exerted at left end of the axle.

F2totx = @(t)cos(omega*t)*F2totxfixed(t)-sin(omega*t)*F2totyfixed(t); % x-comp of the total force exerted at left end of the axle.
F2toty = @(t)sin(omega*t)*F2totxfixed(t)+cos(omega*t)*F2totyfixed(t); % y-comp of the total force exerted at left end of the axle.

%% STEP 3. We plot the determined trajectories.

figure(1);     
clf(1);
plot(linspace(0,T,Nt+1),alpha1,'Color',[0.4660 0.6740 0.1880],'LineWidth',6);
title1 = title('angle $\alpha_1$ versus time');
set(title1,'Interpreter','latex');
xlabel1 = xlabel('t [time]','FontSize',20);
set(xlabel1,'Interpreter','latex');
ylabel1 = ylabel('$\alpha_1$ [intermediate angle]','FontSize',20);
set(ylabel1,'Interpreter','latex');
xt = get(gca,'XTick');
set(gca,'FontSize',20);

figure(2);     
clf(2);
plot(linspace(0,T,Nt+1),gamma1,'b','LineWidth',6);
title1 = title('angle $\gamma_1$ versus time');
set(title1,'Interpreter','latex');
xlabel1 = xlabel('t [time]','FontSize',20);
set(xlabel1,'Interpreter','latex');
ylabel1 = ylabel('$\gamma_1$ [gap angle]','FontSize',20);
set(ylabel1,'Interpreter','latex');
xt = get(gca,'XTick');
set(gca,'FontSize',20);

figure(3);     
clf(3);
plot(linspace(0,T,Nt+1),alpha2,'Color',[0.4660 0.6740 0.1880],'LineWidth',6);
title1 = title('angle $\alpha_2$ versus time');
set(title1,'Interpreter','latex');
xlabel1 = xlabel('t [time]','FontSize',20);
set(xlabel1,'Interpreter','latex');
ylabel1 = ylabel('$\alpha_2$ [intermediate angle]','FontSize',20);
set(ylabel1,'Interpreter','latex');
xt = get(gca,'XTick');
set(gca,'FontSize',20);

figure(4);     
clf(4);
plot(linspace(0,T,Nt+1),gamma2,'b','LineWidth',6);
title1 = title('angle $\gamma_2$ versus time');
set(title1,'Interpreter','latex');
xlabel1 = xlabel('t [time]','FontSize',20);
set(xlabel1,'Interpreter','latex');
ylabel1 = ylabel('$\gamma_2$ [gap angle]','FontSize',20);
set(ylabel1,'Interpreter','latex');
xt = get(gca,'XTick');
set(gca,'FontSize',20);

%% STEP 4. We plot the imbalance indicator along determined trajectory.

figure(9);     
clf(9);
plot(linspace(0,T,Nt+1),G,'Color',[0.8500 0.3250 0.0980],'LineWidth',6);
title1 = title('system response');
set(title1,'Interpreter','latex');
xlabel1 = xlabel('t [time]','FontSize',20); % Seconds
set(xlabel1,'Interpreter','latex');
ylabel1 = ylabel('G [imbalance indicator]','FontSize',20); % Newton^2
set(ylabel1,'Interpreter','latex');
xt = get(gca,'XTick');
set(gca,'FontSize',20);

set_plot_style_v03(36, 30, 6) % Prof. Sakamoto's way to set style of plots.

% varphi1 = alpha1 - gamma1;  % Determine varphi1 given alpha1 and gamma1;
% varphi2 = alpha1 + gamma1;  % Determine varphi2 given alpha1 and gamma1;
% varphi3 = alpha2 - gamma2;  % Determine varphi3 given alpha2 and gamma2;
% varphi4 = alpha2 + gamma2;  % Determine varphi4 given alpha2 and gamma2;
% 
% varphiopt = [varphi1.',varphi2.',varphi3.',varphi4.'];

%% STEP 5. We determine the oscillations of the endpoints of the spindle
%produced by the resulting force imbalance+balance.
%WARNING: only for the balancing head located at z = -a.

Mtot = 10; %total mass of spindle+rotor+balancing heads.
Ntendpos1 = 9000;
time = linspace(1,12,Ntendpos1+1);
% Pxvect = zeros(Ntendpos1+1,1);
% Pyvect = zeros(Ntendpos1+1,1);
% for i=1:Ntendpos1+1
%     [Pxvect(i,1),Pyvect(i,1)] = endpos1(Mtot,F1totx,F1toty,time(i));
%     fprintf("Iteration %i - Pxvect(i,1) %g - Pyvect(i,1) %g\n", i, Pxvect(i,1), Pyvect(i,1));
% end

% head 1
a1 = 6;
a2 = a1;
k1 = 10;%1;
k2 = k1;
gamma1 = a1/Mtot;
omega01 = sqrt(k1/Mtot);
gamma2 = a2/Mtot;
omega02 = sqrt(k2/Mtot);
f1x = @(t)(1/Mtot)*F1totx(t);
f1y = @(t)(1/Mtot)*F1toty(t);
Matrixx = [0,1;-omega01^2,-gamma1];
[~, P1xMATLAB] = ode45(@(t, PxMATLAB) Matrixx*PxMATLAB+[f1x(t);0], time,[0;0]);
Matrixy = [0,1;-omega02^2,-gamma2];
[~, P1yMATLAB] = ode45(@(t, PyMATLAB) Matrixy*PyMATLAB+[f1y(t);0], time,[0;0]);

% head 2
f2x = @(t)(1/Mtot)*F2totx(t);
f2y = @(t)(1/Mtot)*F2toty(t);
[~, P2xMATLAB] = ode45(@(t, PxMATLAB) Matrixx*PxMATLAB+[f2x(t);0], time,[0;0]);
[~, P2yMATLAB] = ode45(@(t, PyMATLAB) Matrixy*PyMATLAB+[f2y(t);0], time,[0;0]);

% figure(10);     
% clf(10);
% plot(P1xMATLAB(1,1),P1yMATLAB(1,1),'*');
% title1 = title('left endpoint');
% set(title1,'Interpreter','latex');
% xlabel1 = xlabel('P_{1x} [x component left endpoint]','FontSize',20); % Seconds
% set(xlabel1,'Interpreter','latex');
% ylabel1 = ylabel('P_{1y} [y component left endpoint]','FontSize',20); % Newton^2
% set(ylabel1,'Interpreter','latex');
% xt = get(gca,'XTick');
% set(gca,'FontSize',20);
% hold on;
% for i=2:size(time,2)
%     plot(P1xMATLAB(i,1),P1yMATLAB(i,1),'*');
%     pause(0.1);
%     hold on;
% end
%%
% figure(11);     
% clf(11);
% plot(P2xMATLAB(1,1),P2yMATLAB(1,1),'*');
% title1 = title('right endpoint');
% set(title1,'Interpreter','latex');
% xlabel1 = xlabel('P_{2,x} [x component right endpoint]','FontSize',20); % Seconds
% set(xlabel1,'Interpreter','latex');
% ylabel1 = ylabel('P_{2,y} [y component right endpoint]','FontSize',20); % Newton^2
% set(ylabel1,'Interpreter','latex');
% xt = get(gca,'XTick');
% set(gca,'FontSize',20);
% hold on;
% for i=2:size(time,2)
%     plot(P2xMATLAB(i,1),P2yMATLAB(i,1),'*','Parent',figure(11));
%     pause(0.1);
%     hold on;
% end

Pxvect = P2xMATLAB;
Pyvect = P2yMATLAB;

if Control
    save('controlled','Pxvect','Pyvect')
else
    save('uncontrolled','Pxvect','Pyvect')
end
%%
% F1totxvect = zeros(Ntendpos1+1,1);
% F1totyvect = zeros(Ntendpos1+1,1);
% for i=1:Ntendpos1+1
%     F1totxvect(i,1) = F1totx(time(i));
%     F1totyvect(i,1) = F1toty(time(i));
% end

% figure(162);
% clf(162);
% plot(F1totxvect,F1totyvect);

%plot_traj_IPOPT