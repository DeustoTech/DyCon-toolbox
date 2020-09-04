%% Two drivers, Flexible time

%import casadi.*

% Parameters and the dynamics
N_sqrt = 4; Nx = N_sqrt^2;

Mx = 2; Nt = 50;

tf = 6;

uf = 0.5*[4;1];

%% Define dynamics using CasADi
t = casadi.SX.sym('t');
symUe = casadi.SX.sym('ue',[2,Nx]);
symVe = casadi.SX.sym('ve',[2,Nx]);
symUd = casadi.SX.sym('ud',[2,Mx]);
symVd = casadi.SX.sym('vd',[2,Mx]);

symY = [symUe(:);symVe(:);symUd(:)];
symU = symVd(:);

square = @(u) (u(1,:).^2+u(2,:).^2);

f_e2 = @(x) repmat(4*exp(-8*x), [2 1]);
kpp= 2; dist_ref = 1/3/N_sqrt;
g_e2 = @(x) repmat(kpp*((-(x+1e-10)+dist_ref)./(x+1e-10)), [2 1]);
a_e2 = @(x) 1;

dot_ve = - 0*symVe;
for j=1:Mx
  dot_ve = dot_ve -f_e2(square(symUd(:,j)-symUe)).*(symUd(:,j)-symUe)/2;
end
for j=1:Nx
 dot_ve = dot_ve -g_e2(square(symUe(:,j)-symUe)).*(symUe(:,j)-symUe)/(Nx-1);
end
for j=1:Nx
 dot_ve = dot_ve +a_e2(square(symUe(:,j)-symUe)).*(symVe(:,j)-symVe)/(Nx-1);
end

symF = [symVe(:)',dot_ve(:)',symU']';
symF_ftn = casadi.Function('symF',{t,symY,symU},{ symF });
% symF_ftn is the vector field for the dynamics
%% Initial data
ve_zero = zeros(2, Nx);
vd_zero = zeros(2, Mx);
ue_zero = zeros(2, Nx);
ud_zero = zeros(2, Mx);

x_zero = 0.2*repmat(linspace(-1,1,N_sqrt),[N_sqrt 1]);
y_zero = x_zero';
ue_zero(1,:) = x_zero(:);
ue_zero(2,:) = y_zero(:);

ud_zero(1,:) = [-1,0];
ud_zero(2,:) = [0,-1];
Y0 = [ue_zero(:);ve_zero(:);ud_zero(:)];

%% Sample trajectory
tline = linspace(0,tf,Nt+1); dt = tf/Nt;
odeEqn = ode(symF_ftn,symY,symU,tline);
SetIntegrator(odeEqn,'RK4')
%%
Y0_tline = zeros(Nt+1,4*Nx+2*Mx);
U0_tline = ([0.2,0.02,0.02,0.2].*(ones(Nt+1,2*Mx)));%+0.5*rand(Nt+1,2*Mx));

YO_tline = Y0_tline;
UO_tline = U0_tline;

YO_tline(1,:) = Y0;
for k=1:Nt
  % Euler forward method
  YO_tline(k+1,:) = YO_tline(k,:) + dt* full(symF_ftn(tline(k),YO_tline(k,:),UO_tline(k,:)))';
end
YT = YO_tline(end,:); Y0_tline = YO_tline;

%%
odeEqn.InitialCondition = Y0;

symL   = 1*1e0/Nx*sum((symUe(1,:)-uf(1)).^2+(symUe(2,:)-uf(2)).^2) + 1e-4/Mx*sum(symU.^2) + 1e-4/Mx*sum((symUd(1,:)-uf(1)).^2+(symUd(2,:)-uf(2)).^2);
symPsi = 1*1e2/Nx*sum((symUe(1,:)-uf(1)).^2+(symUe(2,:)-uf(2)).^2) ;
%symPsi = 0;
PathCost = casadi.Function('symL',{t,symY,symU},{ symL });
FinalCost = casadi.Function('symL',{symY},{ symPsi });

iCP = ocp(odeEqn,PathCost,FinalCost);
%%
tic
ControlGuess = U0_tline';
[OptControl,OptState] = ArmijoGradient(iCP,ControlGuess,'MinLengthStep',1e-20,'maxiter',500);
time_S = toc
U1_tline = OptControl;
%%
GBR_figure(tline,OptState',OptControl',uf);

function [] = GBR_figure(tline,YO_tline,UO_tline,uf)
    [TN Mx] = size(UO_tline);
    [TN NN] = size(YO_tline);
    Mx = Mx/2;
    Nx = (NN - 2*Mx)/4;
    %uf = [1;1];

    %TN = length(tline); 
    dt = tline(2)-tline(1); tline = 0:dt:dt*(TN-1);
    ue_tline = reshape(YO_tline(:,1:2*Nx),[TN 2 Nx]);
    ve_tline = reshape(YO_tline(:,2*Nx+1:4*Nx),[TN 2 Nx]);
    ud_tline = reshape(YO_tline(:,4*Nx+1:4*Nx+2*Mx),[TN 2 Mx]);
    vd_tline = reshape(UO_tline,[TN 2 Mx]);
    Final_Position = reshape(ue_tline(end,:,:),[2 Nx]);
    
    % 1*dt/Np*sum(sum((X_ue(1:Nt_rbm+1,:)-uf(1)).^2+(X_ue(Nt_rbm+2:end,:)-uf(2)).^2))+10*dt/Mx*sum(U(:).^2)
    Final_Psi = 1*dt/Nx*sum(sum((ue_tline(:,1,:)-uf(1)).^2+(ue_tline(:,2,:)-uf(2)).^2,1),3);%+10*dt/Mx*sum(vd_tline(:).^2);
    %Final_Psi = mean( (Final_Position(1,:) - uf(1)).^2+(Final_Position(2,:) - uf(2)).^2 );

    Final_Reg = trapz(tline,mean(UO_tline.^2,2));

    f1 = figure('position', [0, 0, 1000, 400]);

    subplot(1,2,1)
    hold on
    plot(ud_tline(:,1,1),ud_tline(:,2,1),'b-','LineWidth',1.0);
    plot(ue_tline(:,1,1),ue_tline(:,2,1),'r-','LineWidth',1.3);
    for k=2:Nx
      plot(ue_tline(:,1,k),ue_tline(:,2,k),'r-','LineWidth',1.3);
    end
    for k=2:Mx
      plot(ud_tline(:,1,k),ud_tline(:,2,k),'b-','LineWidth',1.0);
    end

    j=1;
    for k=1:Nx
      plot(ue_tline(j,1,k),ue_tline(j,2,k),'r.');
    end
    for k=1:Mx
      plot(ud_tline(j,1,k),ud_tline(j,2,k),'bs');
    end
    j=TN;
    for k=1:Nx
      plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
    end
    for k=1:Mx
      plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
    end
    plot(uf(1),uf(2),'ks','MarkerSize',20)

    legend('Drivers','Evaders','Location','best')
    xlabel('abscissa')
    ylabel('ordinate')
    %ylim([-2.5 1.5])
    title(['Position error = ', num2str(Final_Psi)])
    set(gca,'fontsize', 18);
    grid off

    subplot(1,2,2)
    hold on
    for k=1:Mx
        plot(tline,(vd_tline(:,1,k)+vd_tline(:,2,k))/sqrt(2),'r-','LineWidth',1.3)
        plot(tline,(-vd_tline(:,1,k)+vd_tline(:,2,k))/sqrt(2),'b-','LineWidth',1.3)
    end
    xlim([tline(1) tline(end)])
    %legend('Driver1','Driver2')
    xlabel('Time')
    ylabel('Controls')
    %title(['Total Time = ',num2str(tline(end)),' and running cost = ',num2str(Final_Reg)])
    title(['Control cost = ',num2str(Final_Reg)])
    set(gca,'fontsize', 18);
    grid on

end
