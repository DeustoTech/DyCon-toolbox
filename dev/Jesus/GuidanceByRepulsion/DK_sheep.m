%% Two drivers, Fixed time

N_sqrt = 3;
M = 2; N = N_sqrt^2;

Y = sym('y',[4*(M+N) 1]);
U = sym('u',[M 1]);
ue = reshape(Y(1:2*N),[2 N]);
ve = reshape(Y(2*N+1:4*N),[2 N]);
ud = reshape(Y(4*N+1:4*N+2*M),[2 M]);
vd = reshape(Y(4*N+2*M+1:4*M+4*N),[2 M]);

kappa = U(1:M);
T = 1;

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
  dot_ve = dot_ve -f_e2(square(ud(:,j)-ue)).*(ud(:,j)-ue);
end

%Y = [ue(:);ve(:);ud(:);vd(:)];
F = [dot_ue(:);dot_ve(:);dot_ud(:);dot_vd(:)];
t = sym('t');
F = matlabFunction(F,'Vars',{t,Y,U,sym.empty});
%%
ve_zero = zeros(2, N);
vd_zero = zeros(2, M);

ue_zero = zeros(2, N);
ud_zero = zeros(2, M);

x_zero = repmat(linspace(-1,1,N_sqrt),[N_sqrt 1]);
y_zero = x_zero';
ue_zero(1,:) = x_zero(:);
ue_zero(2,:) = y_zero(:);

for j=1:M
  ud_zero(:,j) = 5*[cos(2*pi/M*j);sin(2*pi/M*j)];
end

Y0 = [ue_zero(:);ve_zero(:);ud_zero(:);vd_zero(:)];

%%

% T=5.1725, kappa = 1.5662 -> [-1,1]
dt = 0.1;
dynamics = ode(F,Y,U,'FinalTime',10,'Nt',100);
dynamics.InitialCondition = Y0;
%%
tspan = dynamics.tspan;

U0_tline = [repmat(2.8*ones(size(tspan')),[1 M])];
u_f = [0;0];

dynamics.Control.Numeric = U0_tline;
%options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dynamics.Solver=@ode23tb;
%dynamics.SolverParameters={options};
solve(dynamics);
%plot(dynamics)


TN = length(tspan);
UO_tline = U0_tline;    % Controls
YO_tline = dynamics.StateVector.Numeric;
%tline_UO = dt*cumtrapz(UO_tline(:,end)); % timeline based on the values of t, which is the integration of T(s)ds.
tline_UO = tspan;
% Cost calcultaion
Final_Time = tline_UO(end);

ue_tline = reshape(YO_tline(:,1:2*N),[TN 2 N]);
%ve_tline = reshape(YO_tline(:,2*N+1:4*N),[TN 2 N]);
ud_tline = reshape(YO_tline(:,4*N+1:4*N+2*M),[TN 2 M]);
%vd_tline = reshape(YO_tline(:,4*N+2*M+1:4*M+4*N),[TN 2 M]);
Final_Position = reshape(ue_tline(end,:,:),[2 N]);

Final_Psi = mean( (Final_Position(1,:) - u_f(1)).^2+(Final_Position(2,:) - u_f(2)).^2 );

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

%plot(u_f(1),u_f(2),'ks','MarkerSize',20)

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
tic
Psi = sum( (ue(1,:)-u_f(1)).^2+(ue(2,:)-u_f(2)).^2 );
L   = 0.001*(kappa.'*kappa)*T;%+0.000*(Y.'*Y)+00*(Y_e-Y_f).'*(Y_e-Y_f) ;

iP = Pontryagin(dynamics,Psi,L);
toc
%iP.ode.Control.Numeric = ones(51,1);
%iP.constraints.Umax = 1.7;
%iP.constraints.Umin = -1.7;
%iP.constraints.Projection = @(Utline) [Utline(:,1),0.5*(Utline(:,end)+abs(Utline(:,end)))];
%%
%tline = dynamics.tspan;
%temp = interp1(tline1,temp1,tline);
%%
%U0_tline = 1.5662*ones([length(tline),2]);
%U0_tline = [-0.5*ones([length(tline),1]),0.5*ones([length(tline),1])];


GradientMethod(iP,U0_tline,'DescentAlgorithm',@AdaptativeDescent,'tol',1e-6,'Graphs',false,'display','all');
%GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'},'tol',1e-6,'Graphs',true,'U0',U0_tline,'MaxIter',100);

%iP.solution
%plot(iP)
temp = iP.solution.UOptimal;
%%
UO_tline = iP.solution.UOptimal;    % Controls
YO_tline = iP.solution.Yhistory(end);
YO_tline = YO_tline{1};   % Trajectories
JO = iP.solution.JOptimal;    % Cost
zz = YO_tline;
tline_UO = tspan; % timeline based on the values of t, which is the integration of T(s)ds.
% Cost calcultaion
Final_Time = tline_UO(end);

TN = length(tspan);

ue_tline = reshape(YO_tline(:,1:2*N),[TN 2 N]);
%ve_tline = reshape(YO_tline(:,2*N+1:4*N),[TN 2 N]);
ud_tline = reshape(YO_tline(:,4*N+1:4*N+2*M),[TN 2 M]);
%vd_tline = reshape(YO_tline(:,4*N+2*M+1:4*M+4*N),[TN 2 M]);
Final_Position = reshape(ue_tline(end,:,:),[2 N]);

Final_Psi = mean( (Final_Position(1,:) - u_f(1)).^2+(Final_Position(2,:) - u_f(2)).^2 );

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

%plot(u_f(1),u_f(2),'ks','MarkerSize',20)

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