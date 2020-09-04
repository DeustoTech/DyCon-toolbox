clear;
% Generate data
N = 12;
xdata = linspace(-1,1,N);
ydata = [-1, -1, -1, -1, 1, 1, 1, 1, -1, -1, -1, -1];
%%
sigma = @(x) tanh(x);
%% Dynamic definition
import casadi.*
As = SX.sym('A',[2 2]);
bs = SX.sym('b',[2 1]);
zs = SX.sym('z',[2*N 1]);
% Create a Big matrices
Afull =  SX.zeros(2*N,2*N);
for i = 1:N
   ind = ((i-1)*2+1):(i*2);
   Afull(ind,ind) = As; 
end
%
bfull = repmat(bs,N,1);
% sym time
ts = SX.sym('t');
% this is the control
us = [As(:);bs];
% define the dynamic equation
Fs = casadi.Function('F',{ts,zs,us},{Afull*sigma(zs) + bfull});
% 
Nt = 50; tspan = linspace(0,1,Nt);
%
idyn = ode(Fs,zs,us,tspan); % <- idyn is a ode object of DyCon Toolbox
SetIntegrator(idyn,'RK4') % <- For solve you need choose a numerical squeme
% initial condition
z0          = zeros(2*N,1);
z0(1:2:2*N) = xdata';
% put in idyn object 
idyn.InitialCondition = z0;
%% Optimal Control Definition
P = [1 1]; % no optimize P
Pfull = repmat(P,N,1);
Pzminusy = P*reshape(zs,2,N)-ydata; % <-- (P*z_i - y_i)
L   = casadi.Function('L',  {ts,zs,us},{ sum(sum(As.^2))  + bs'*bs  + 1e5*(Pzminusy*Pzminusy')});
Psi = casadi.Function('Psi',{zs}      ,{ 1e5*(Pzminusy*Pzminusy') });
%
iocp = ocp(idyn,L,Psi);
%[Uopt,Zopt] = IpoptSolver(iocp,ZerosControl(idyn));
[Uopt,Zopt] = ArmijoGradient(iocp,ZerosControl(idyn));

%% Plot
figure(1)
clf
subplot(1,2,1)
l1 = plot(tspan,Zopt(1:2:2*N,:)','b');
hold on
l2 = plot(tspan,Zopt(2:2:2*N,:)','r');
legend([l1(1) l2(1)],{'z_i^1(t)','z_i^2(t)'},'Location','bestoutside')

title('Optimal State')
ylabel('z_i(t)')
xlabel('time')

subplot(2,2,2)
plot(tspan,Uopt(1:4,:)')
title('Optimal Control - A(t)')
xlabel('time')
legend({'A_1','A_2','A_3','A_4'},'Location','bestoutside')

subplot(2,2,4)
plot(tspan,Uopt(5:end,:)')
title('Optimal Control - b(t)')
xlabel('time')
legend({'b_1','b_2'},'Location','bestoutside')
%% Animation
fig = figure(2);
clf
hold on

xlim([-5 5])

ylim([-5 5])
for iter = 1:N
    if ydata(iter) > 0
        color = 'r';
    else
        color = 'b';
    end
    ilines(iter) = plot(Zopt(2*(iter-1)+1,1),Zopt(2*(iter-1)+2,1),'Color',color,'Marker','.','MarkerSize',20);
    jlines(iter) = plot(Zopt(2*(iter-1)+1,1),Zopt(2*(iter-1)+2,1),'Color',color,'Marker','none','MarkerSize',20);

end
% 
for it = 1:length(tspan)
   for iter = 1:N
    ilines(iter).XData = Zopt(2*(iter-1)+1,it);
    ilines(iter).YData = Zopt(2*(iter-1)+2,it);
    jlines(iter).XData = Zopt(2*(iter-1)+1,1:it);
    jlines(iter).YData = Zopt(2*(iter-1)+2,1:it);
   end
    pause(0.05)
end


