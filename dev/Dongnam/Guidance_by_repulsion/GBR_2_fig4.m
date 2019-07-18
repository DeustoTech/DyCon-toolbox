%% Two drivers, Flexible time

global N M uf Nt

N_sqrt =1;
M = 2; N = N_sqrt^2;

syms t
Y = sym('y',[4*(M+N) 1]);
U = sym('u',[M+1 1]);

ue = reshape(Y(1:2*N),[2 N]);
ve = reshape(Y(2*N+1:4*N),[2 N]);
ud = reshape(Y(4*N+1:4*N+2*M),[2 M]);
vd = reshape(Y(4*N+2*M+1:4*M+4*N),[2 M]);

kappa = U(1:M);
T = U(end);

perp = @(u) [-u(2,:);u(1,:)];
square = @(u) u(1,:).^2+u(2,:).^2;

f_e2 = @(x) repmat(2./x, [2 1]);
f_d2 = @(x) repmat(-(-5.5./x+10./x.^2-2),[2 1]);
nu_e = 2.0;
nu_d = 2.0;

dot_ue = ve;
dot_ud = vd;
uebar = mean(ue,2);

dot_vd = -f_d2(square(ud-uebar)).*(ud-uebar) - nu_d*vd + repmat(kappa',[2 1]).*perp(ud-uebar);

dot_ve = - nu_e*ve;
for j=1:M
  dot_ve = dot_ve -f_e2(square(ud(:,j)-ue)).*(ud(:,j)-ue)/M;
end

%Y = [ue(:);ve(:);ud(:);vd(:)];
F = [dot_ue(:);dot_ve(:);dot_ud(:);dot_vd(:)]*T;
numF = matlabFunction(F,'Vars',{t,Y,U});
%%
ve_zero = zeros(2, N);
vd_zero = zeros(2, M);

ue_zero = zeros(2, N);
ud_zero = [[-3;0.5] [-3;-0.5]];

% for j=1:M
%   ud_zero(:,j) = 3*[cos(2*pi/M*j);sin(2*pi/M*j)];
% end

Y0 = [ue_zero(:);ve_zero(:);ud_zero(:);vd_zero(:)];

% %%
% figure()
% hold on
% 
% plot(ue_zero(1,:),ue_zero(2,:),'ro');
% plot(ud_zero(1,:),ud_zero(2,:),'bo');


%%

% T=5.1725, kappa = 1.5662 -> [-1,1]
Nt = 100;
dt = 1/(Nt-1);
dynamics = ode(numF,Y,U,'FinalTime',1,'Nt',Nt);
dynamics.InitialCondition = Y0;
%%
tline = dynamics.tspan;
U0_tline = [1.5662*ones([length(tline),M]),5.1727*ones([length(tline),1])];
%U0_tline = [UO_tline,1*ones([length(tline),1])];
uf = [-1;1];

dynamics.Control.Numeric = U0_tline;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dynamics.Solver=@eulere;
%dynamics.SolverParameters={options};
%dynamics.Solver=@eulere;
%dynamics.SolverParameters={};

solve(dynamics);
%plot(dynamics)


TN = length(tline);
UO_tline = U0_tline;    % Controls
YO_tline = dynamics.StateVector.Numeric;
tline_UO = dt*cumtrapz(UO_tline(:,end)); % timeline based on the values of t, which is the integration of T(s)ds.
% Cost calcultaion
Final_Time = tline_UO(end);

ue_tline = reshape(YO_tline(:,1:2*N),[TN 2 N]);
%ve_tline = reshape(YO_tline(:,2*N+1:4*N),[TN 2 N]);
ud_tline = reshape(YO_tline(:,4*N+1:4*N+2*M),[TN 2 M]);
%vd_tline = reshape(YO_tline(:,4*N+2*M+1:4*M+4*N),[TN 2 M]);
Final_Position = reshape(ue_tline(end,:,:),[2 N]);

Final_Psi = mean( (Final_Position(1,:) - uf(1)).^2+(Final_Position(2,:) - uf(2)).^2 );

Final_Reg = trapz(tline_UO,mean(UO_tline(:,1:M).^2,2));

f1 = figure('position', [0, 0, 1000, 400]);

subplot(1,2,1)
hold on
plot(ud_tline(:,1,1),ud_tline(:,2,1),'b-','LineWidth',1.0);
plot(ue_tline(:,1,1),ue_tline(:,2,1),'r-','LineWidth',1.3);
for k=2:N
  plot(ue_tline(:,1,k),ue_tline(:,2,k),'r-','LineWidth',1.3);
end
for k=2:M
  plot(ud_tline(:,1,k),ud_tline(:,2,k),'b-','LineWidth',1.0);
end

j=1;
for k=1:N
  plot(ue_tline(j,1,k),ue_tline(j,2,k),'r.');
end
for k=1:M
  plot(ud_tline(j,1,k),ud_tline(j,2,k),'bs');
end

% j=floor(1/Final_Time/dt);
% for k=1:N
%   plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
% end
% for k=1:M
%   plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
% end
% 
% j=length(tline);
% for k=1:N
%   plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
% end
% for k=1:M
%   plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
% end

%plot(uf(1),uf(2),'ks','MarkerSize',20)

legend('Drivers','Evaders','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')
%ylim([-2.5 1.5])
title(['Position error = ', num2str(Final_Psi)])
grid on

subplot(1,2,2)
plot(tline_UO,UO_tline(:,1:M),'LineWidth',1.3)
xlim([tline_UO(1) tline_UO(end)])
%legend('Driver1','Driver2')
xlabel('Time')
ylabel('Control \kappa(t)')
title(['Total Time = ',num2str(tline_UO(end)),' and running cost = ',num2str(Final_Reg)])
grid on

%%


Psi = 1e4*sum(sum((ue - uf).^2));
L   = (kappa.'*kappa)*T;
numPsi = matlabFunction(Psi,'Vars',{t,Y});
numL = matlabFunction(L,'Vars',{t,Y,U});

iP = Pontryagin(dynamics,numPsi,numL);
%iP.ode.Control.Numeric = ones(51,1);
iP.Constraints.MaxControl= 10;
iP.Constraints.MinControl = -10;
%%
tline = iP.Dynamics.tspan;
%temp = interp1(tline1,temp1,tline);
%%

tol = 1e-6;
GradientMethod(iP,U0_tline,'DescentAlgorithm',@ConjugateDescent, ...
                           'tol',tol,'tolU',tol,'tolJ',tol,'display','all','EachIter',20,'Graphs',true, ...
                           'GraphsFcn',{@graphs_init_GBR_flextime,@graphs_iter_GBR_flextime});
temp = iP.Solution.UOptimal;

%%
tol = 1e-9;
GradientMethod(iP,temp,'DescentAlgorithm',@ConjugateDescent, ...
                           'tol',tol,'tolU',tol,'tolJ',tol,'display','all','EachIter',20,'Graphs',true, ...
                           'GraphsFcn',{@graphs_init_GBR_flextime,@graphs_iter_GBR_flextime});
temp = iP.Solution.UOptimal;
tline = iP.Dynamics.tspan;
%%
temp_old = temp;
tline_old = tline;
%%
Nt = 1000;
iP.Dynamics.Nt = Nt;
dt = 1/Nt;
tline = iP.Dynamics.tspan;
temp = interp1(tline_old,temp_old,tline);
%%
tol = 1e-6;
GradientMethod(iP,temp,'DescentAlgorithm',@ConjugateDescent, ...
                           'tol',tol,'tolU',tol,'tolJ',tol,'display','all','EachIter',20,'Graphs',true,'MaxIter',100, ...
                           'GraphsFcn',{@graphs_init_GBR_flextime,@graphs_iter_GBR_flextime});
temp = iP.Solution.UOptimal;
tline = iP.Dynamics.tspan;


%%
UO_tline = iP.Solution.UOptimal;    % Controls
YO_tline = iP.Solution.Yhistory(end);
YO_tline = YO_tline{1};   % Trajectories
JO = iP.Solution.JOptimal;    % Cost

tline_UO = dt*cumtrapz(UO_tline(:,end)); % timeline based on the values of t, which is the integration of T(s)ds.
ue_tline = reshape(YO_tline(:,1:2*N),[Nt 2 N]);
%ve_tline = reshape(YO_tline(:,2*N+1:4*N),[Nt 2 N]);
ud_tline = reshape(YO_tline(:,4*N+1:4*N+2*M),[Nt 2 M]);
%vd_tline = reshape(YO_tline(:,4*N+2*M+1:4*M+4*N),[Nt 2 M]);
Final_Position = reshape(ue_tline(end,:,:),[2 N]);

Final_Psi = mean( (Final_Position(1,:) - uf(1)).^2+(Final_Position(2,:) - uf(2)).^2 );

Final_Reg = trapz(tline_UO,mean(UO_tline(:,1:M).^2,2));

% Cost calcultaion
Final_Time = tline_UO(end);

Final_Position1 = [ue_tline(end,1,1);ue_tline(end,2,1)];
Final_Position1 = [ue_tline(end,1,1);ue_tline(end,2,1)];
Final_Psi = (Final_Position1 - uf).'*(Final_Position1 - uf)+(Final_Position2 - uf).'*(Final_Position2 - uf);
Final_Psi = Final_Psi/2;

Final_Reg = cumtrapz(tline_UO,(UO_tline(:,1).^2+UO_tline(:,2).^2)/2);
Final_Reg = Final_Reg(end);

f1 = figure('position', [0, 0, 1000, 350]);

subplot(1,2,1)
hold on
plot(ud_tline(:,1,1),ud_tline(:,2,1),'b--','LineWidth',1.3);
plot(ue_tline(:,1,1),ue_tline(:,2,1),'r-','LineWidth',1.2);
for k=1:M
plot(ud_tline(:,1,k),ud_tline(:,2,k),'b--','LineWidth',1.3);
end
for k=1:N
plot(ue_tline(:,1,k),ue_tline(:,2,k),'r-','LineWidth',1.2);
end
j=1;
for k=1:N
plot(ue_tline(j,1,k),ue_tline(j,2,k),'rs');
end
for k=1:M
plot(ud_tline(j,1,k),ud_tline(j,2,k),'bs');
end

[~,j]=min(abs(tline_UO-1));
for k=1:N
plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
end
for k=1:M
plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
end

[~,j]=min(abs(tline_UO-2));
for k=1:N
plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
end
for k=1:M
plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
end

[~,j]=min(abs(tline_UO-3));
for k=1:N
plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
end
for k=1:M
plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
end

[~,j]=min(abs(tline_UO-4));
for k=1:N
plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
end
for k=1:M
plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
end

j=length(tline_UO);
for k=1:N
plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
end
for k=1:M
plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
end
plot([uf(1)],[uf(2)],'ks','MarkerSize',20)
legend('Drivers','Evader','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')
%ylim([-2.5 1.5])
title(['Position error = ', num2str(Final_Psi)])
grid on

subplot(1,2,2)
tline_UO = dt*cumtrapz(UO_tline(:,end));
plot(tline_UO,UO_tline(:,2),'LineWidth',1.3)
hold on
plot(tline_UO,UO_tline(:,1),'LineWidth',1.3)
xlim([tline_UO(1) tline_UO(end)])
legend('Driver1','Driver2')
xlabel('Time')
ylabel('Control \kappa(t)')
title(['Total Time = ',num2str(tline_UO(end)),' and running cost = ',num2str(Final_Reg)])
grid on

