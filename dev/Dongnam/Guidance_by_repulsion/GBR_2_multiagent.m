%% Two drivers, Flexible time

global N M u_f Nt tf

N_sqrt =4;
M =1; N = N_sqrt^2;

syms t
Y = sym('y',[4*(M+N) 1]);
U = sym('u',[M 1]);

ue = reshape(Y(1         : 2*N    ), [2 N]);
ve = reshape(Y(2*N+1     : 4*N    ), [2 N]);
ud = reshape(Y(4*N+1     : 4*N+2*M), [2 M]);
vd = reshape(Y(4*N+2*M+1 : 4*M+4*N), [2 M]);

kappa = U(1:M);

perp = @(u) [-u(2,:);u(1,:)];
square = @(u) u(1,:).^2+u(2,:).^2;

f_e2 = @(x) repmat(2./x, [2 1]);
f_d2 = @(x) repmat(-(-5.5./x+10./x.^2-2),[2 1]);


f_d3 = @(x) repmat(+(-5.5./x+10./x.^2-2),[2 1]);

nu_e = 2.0;
nu_d = 2.0;

dot_ue = ve;
dot_ud = vd;
uebar = mean(ue,2);

dot_vd = -f_d2(square(ud-uebar)).*(ud-uebar) - nu_d*vd + repmat(kappa.',[2 1]).*perp(ud-uebar);

dot_ve = - nu_e*ve;
for j=1:M
  dot_ve = dot_ve - f_e2(square(ud(:,j)-ue)).*(ud(:,j)-ue);
end

for j=1:M
  dot_ve = dot_ve - f_e2(square(ud(:,j)-ue)).*(ud(:,j)-ue);
end
F = [dot_ue(:);dot_ve(:);dot_ud(:);dot_vd(:)];
numF = matlabFunction(F,'Vars',{t,Y,U,sym.empty});

ve_zero = zeros(2, N);
vd_zero = zeros(2, M);

ue_zero = zeros(2, N);
ud_zero = zeros(2, M);

x_zero = repmat(linspace(-1,1,N_sqrt),[N_sqrt 1]);
y_zero = x_zero';
ue_zero(1,:) = x_zero(:);
ue_zero(2,:) = y_zero(:);

for j=1:M
  ud_zero(:,j) = 3*[cos(2*pi/M*j);sin(2*pi/M*j)];
end

Y0 = [ue_zero(:);ve_zero(:);ud_zero(:);vd_zero(:)];


tf = 10;
Nt = 100;
dt = 1/(Nt-1);
dynamics = ode(numF,Y,U,'FinalTime',tf,'Nt',Nt);
dynamics.Solver = @eulere;
dynamics.InitialCondition = Y0;
%%
tline = dynamics.tspan;
U0_tline = 2*[rand([length(tline),M])];
%%
u_f = [-5;5];

dynamics.Control.Numeric = U0_tline;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dynamics.Solver=@eulere;


solve(dynamics);
plot(dynamics)


TN = length(tline);
UO_tline = U0_tline;    % Controls
YO_tline = dynamics.StateVector.Numeric;
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


Psi = 1e4*(1/N)*sum(sum((ue - u_f).^2));
L   = (kappa.'*kappa);
numPsi = matlabFunction(Psi,'Vars',{t,Y});
numL = matlabFunction(L,'Vars',{t,Y,U});

iP = Pontryagin(dynamics,numPsi,numL,'SymbolicCalculations',true);
%iP.ode.Control.Numeric = ones(51,1);
%%
iP.Constraints.MaxControl = +5;
iP.Constraints.MinControl = -5;
%%
%DiscreteProblemFmincon(iP)

%%

% AMPLFile(iP,'Dongnam.txt','StateGuess',YO_tline,'ControlGuess',U0_tline)
% %%
% out = SendNeosServer('Dongnam.txt');
% data = NeosLoadData(out);
% %%
% YO_tline = data.State';
%%
out='/home/djoroya/Documentos/GitHub/DyCon-toolbox/tmp/AMPL-executions/09-Jul-2019-11-16-513021-196596-Dongnam.txt/Dongnam.txt.out';
data = NeosLoadData(out);
%%
YO_tline = data.State';
%%

tline = iP.Dynamics.tspan;
%temp = interp1(tline1,temp1,tline);
%%
%U0_tline = 1.5662*ones([length(tline),2]);
%U0_tline = [-0.5*ones([length(tline),1]),0.5*ones([length(tline),1])];
U0_tline = 2 + zeros(length(iP.Dynamics.tspan),iP.Dynamics.ControlDimension);
% 
%%
U0_tline = GradientMethod(iP,U0_tline,'DescentAlgorithm',@ConjugateDescent, ...
                          'tol',1e-7,'display','all','EachIter',2,'Graphs',true, ...
                          'GraphsFcn',{@graphs_init_GBR,@graphs_iter_GBR});
%%                     
tol = 1e-9;U0_tline =GradientMethod(iP,0*U0_tline,'DescentAlgorithm',@ClassicalDescent,'DescentParameters',{'FixedLengthStep',true,'LengthStep',1e-8}, ...
                           'tol',tol,'tolU',tol,'tolJ',tol,'display','all','EachIter',10,'Graphs',true, ...
                           'GraphsFcn',{@graphs_init_GBR,@graphs_iter_GBR},'MaxIter',10000);
%%
                       % %                        
% U0_tline = iP.Solution.UOptimal;
% 
% GradientMethod(iP,U0_tline,'DescentAlgorithm',@ConjugateDescent, ...
%                            'tol',1e-7,'display','all','EachIter',10,'Graphs',false, ...
%                            'GraphsFcn',{@graphs_init_sheep_dog,@graphs_iter_sheep_dog},'MaxIter',5000);
% %             
%U0_tline = iP.Solution.UOptimal;
% GradientMethod(iP,U0_tline,'DescentAlgorithm',@ConjugateDescent, ...
%                            'DescentParameters',{'StopCriteria','Jdiff','DirectionParameter','PPR'}, ...
%                            'tol',1e-7,'Graphs',false,'EachIter',10,'display','all');
%%
options = optimoptions(@fminunc,'SpecifyObjectiveGradient',true,'display','iter','StepTolerance',1e-9,'MaxIterations',1e5)
%temp = fminunc(@(U) Control2Functional(iP,U),U0_tline,options);

temp = fmincon(@(U) Control2Functional(iP,U),50.0 + 0.0*U0_tline, [],[], ... 
                                                       [],[], ...
                                                       U0_tline*0 - 5,U0_tline*0 + 5, ...
                                                       [],    ...
                                                       options);


[~ ,YO_tline] = solve(iP.Dynamics,'Control',temp);
%iP.solution
%plot(iP)
%temp = iP.Solution.UOptimal;
%%
%temp = temp3;
%temp = try1;
%GradientMethod(iP,'DescentAlgorithm',@ConjugateDescent,'DescentParameters',{'DirectionParameter','PPR'},'tol',1e-10,'Graphs',true,'U0',temp);
%GradientMethod(iP,'DescentAlgorithm',@AdaptativeDescent,'Graphs',true,'U0',temp);
%plot(iP)
%temp = iteP.Solution.UOptimal;

%% Jesus Plot
%figure

%YO_tline = iP.Solution.Yhistory(end);
% YO_tline = YO_tline{1};   % Trajectories
% zz = YO_tline;
zz = YO_tline;

uePlot = zz(:,1:2*N);

uePx = uePlot(:,1:2:2*N);
uePy = uePlot(:,2:2:2*N);
 plot(uePx,uePy,'r-')
 hold on
% 
vePlot = zz(:,4*N+1:4*N+2*M);
% 
vePx = vePlot(:,1:2:2*M);
vePy = vePlot(:,2:2:2*M);
% 
plot(vePx,vePy,'b-')


figure
lv = plot(vePx(1,:),vePy(1,:),'bo');
hold on
lu = plot(uePx(1,:),uePy(1,:),'ro');
xlim([-10 10])
ylim([-10 15])


for it = 1:TN-1
    lv.XData = vePx(it,:);lv.YData = vePy(it,:);
    lu.XData = uePx(it,:);lu.YData = uePy(it,:);
    pause(0.1)
end





