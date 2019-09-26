%% Two drivers, Flexible time

global N M u_f Nt tf

N_sqrt =7;
M = 3; N = N_sqrt^2;

syms t
Y = sym('y',[4*(M+N) 1]);
U = sym('u',[M 1],'real');

ue = reshape(Y(1:2*N),[2 N]);
ve = reshape(Y(2*N+1:4*N),[2 N]);
ud = reshape(Y(4*N+1:4*N+2*M),[2 M]);
vd = reshape(Y(4*N+2*M+1:4*M+4*N),[2 M]);

kappa = U(1:M);
%T = U(end);

perp = @(u) [-u(2,:);u(1,:)];
square = @(u) u(1,:).^2+u(2,:).^2;

f_e2 = @(x) repmat(2./x, [2 1]);
f_d2 = @(x) repmat(-(-5.5./x+10./x.^2-2),[2 1]);
f_glu = @(x) repmat(-5*exp(-x.^2) + exp(-x.^2/(0.01^2)), [2 1]);
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

for j=1:N
  dot_ve = dot_ve -0.3*f_glu(square(ue(:,j)-ue)).*(ue(:,j)-ue);
end


%Y = [ue(:);ve(:);ud(:);vd(:)];
F = [dot_ue(:);dot_ve(:);dot_ud(:);dot_vd(:)];
numF = matlabFunction(F,'Vars',{t,Y,U,sym.empty});
%%
ve_zero = 0.8*ones(2, N);
vd_zero = zeros(2, M);

ue_zero = zeros(2, N);
ud_zero = zeros(2, M);

if N == 1
  ue_zero = [0;0];
else
  x_zero = repmat(linspace(-0.35,0.35,N_sqrt),[N_sqrt 1]);
  y_zero = x_zero';
  ue_zero(1,:) = x_zero(:);
  ue_zero(2,:) = y_zero(:);
end

[n1,n2] = size(ue_zero);
ue_zero = ue_zero + 0.2*rand(n1,n2)
for j=1:M
  ud_zero(:,j) = 2*[cos(2*pi/M*j);sin(2*pi/M*j)];
end

[n1,n2] = size(ud_zero);
ud_zero = ud_zero + 0.75*rand(n1,n2)

Y0 = [ue_zero(:);ve_zero(:);ud_zero(:);vd_zero(:)];

% %%
% figure()
% hold on
% 
% plot(ue_zero(1,:),ue_zero(2,:),'ro');
% plot(ud_zero(1,:),ud_zero(2,:),'bo');


%%

% T=5.1725, kappa = 1.5662 -> [-1,1]
tf = 3.5
Nt = 201;
dt = 1/(Nt-1);
dynamics = ode(numF,Y,U,'FinalTime',tf,'Nt',Nt);
dynamics.InitialCondition = Y0;
%
tline = dynamics.tspan;
U0_tline = [1*ones([length(tline),M])];
%

[xms,tms] = meshgrid(1:M,tline)
U0_tline = 1+0*sin(pi*tms/tf)

%

%U0_tline = [UO_tline,1*ones([length(tline),1])];
u_f = [2;2];

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
%tline_UO = dt*cumtrapz(UO_tline(:,end)); % timeline based on the values of t, which is the integration of T(s)ds.
tline_UO = tline;
% Cost calcultaion
Final_Time = tline_UO(end);

ue_tline = reshape(YO_tline(:,1:2*N),[TN 2 N]);
%ve_tline = reshape(YO_tline(:,2*N+1:4*N),[TN 2 N]);
ud_tline = reshape(YO_tline(:,4*N+1:4*N+2*M),[TN 2 M]);
%vd_tline = reshape(YO_tline(:,4*N+2*M+1:4*M+4*N),[TN 2 M]);
Final_Position = reshape(ue_tline(end,:,:),[2 N]);

Final_Psi = mean( (Final_Position(1,:) - u_f(1)).^2+(Final_Position(2,:) - u_f(2)).^2 );

Final_Reg = trapz(tline_UO,mean(UO_tline(:,1:M).^2,2));
%%
clf
fig = figure
ax = axes('unit','norm','pos',[0 0 1 1]);
axis(ax,'off')
hold on

Colors = jet(N)
for k=1:N
  line(ue_tline(:,1,k),ue_tline(:,2,k),'Color',Colors(k,:),'LineWidth',1.0);
line(ue_tline(end,1,k),ue_tline(end,2,k),'Color',Colors(k,:),'LineWidth',1.3,'MarkerSize',15.0,'Marker','.');

end
%
for k=1:M
  line(ud_tline(1:end-2,1,k),ud_tline(1:end-2,2,k),'Color','k','LineWidth',3.5,'Marker','none');
  line(ud_tline(1,1,k),ud_tline(1,2,k),'Color','k','MarkerSize',15.0,'Marker','.');

   Xss = [ud_tline(end-2,:,k)];
   Yss = [ud_tline(end,:,k)];
    dataArrow(Xss,Yss)
end

%
Xmean = mean(ue_tline(end,1,:))
Ymean = mean(ue_tline(end,2,:))
Xsize = 0.5;
Ysize = 0.5;

ir = rectangle('Position',[Xmean-0.5*Xsize Ymean-0.5*Ysize Xsize Ysize]);
ir.LineWidth = 3;
grid on
daspect([1 1 1])
xlim([-3 3.6])
ylim([-2 2.7])
%
xlim([-1.5 2.5])
ylim([-1.5 2.5])
%%
saveas(fig,'Barchart.png')
%%
ani(ud_tline,ue_tline,N,M)


%% 
function ani(ud_tline,ue_tline,N,M)
fig = figure;
ax = axes('unit','norm','pos',[0 0 1 1]);
axis(ax,'off')
hold on

Colors = jet(N);

 
for k=1:N
  line_evader(k) = line(ue_tline(1,1,k),ue_tline(1,2,k),'Color',Colors(k,:),'LineWidth',0.25,'Marker','o');
  line(ue_tline(1,1,k),ue_tline(1,2,k),'Color',Colors(k,:),'LineWidth',1.3,'MarkerSize',15.0,'Marker','.');

end
%
for k=1:M
  line_driver(k) = line(ud_tline(1,1,k),ud_tline(1,2,k),'Color','k','LineWidth',2.0,'Marker','o');
  line(ud_tline(1,1,k),ud_tline(1,2,k),'Color','k','MarkerSize',15.0,'Marker','.');
end

for it = 1:length(ud_tline(:,1,k))
    for k=1:N
        line_evader(k).XData = ue_tline(it,1,k);
        line_evader(k).YData = ue_tline(it,2,k);
    end
    %
    for k=1:M
        line_driver(k).XData = ud_tline(it,1,k);
        line_driver(k).YData = ud_tline(1:it,2,k);
        
    end
    pause(0.1)
end
end
%%
function obj = dataArrow(p1,p2)
%This function will draw an arrow on the plot for the specified data.
%The inputs are 

dp = p2-p1;                         % Difference
qu =quiver(p1(1),p1(2),dp(1),dp(2),0);
qu.LineWidth = 10.3;
qu.Color = [0 0 0];
end
