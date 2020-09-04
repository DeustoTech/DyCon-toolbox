%% Two drivers, Flexible time

%import casadi.*

% Parameters and the dynamics
N_sqrt = 6; Nx = N_sqrt^2;

Mx = 2;
Nt = 30;

tf = 3;

uf = 0.5*[1;1];

%% Define dynamics using CasADi
t = casadi.SX.sym('t');
symUe = casadi.SX.sym('ue',[2,Nx]);
symVe = casadi.SX.sym('ve',[2,Nx]);
symUd = casadi.SX.sym('ud',[2,Mx]);
symVd = casadi.SX.sym('vd',[2,Mx]);

symY = [symUe(:);symVe(:);symUd(:)];
%symP = casadi.SX.sym('p',[4*Nx+2*Mx,1]);
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

symF_x = jacobian(symF,symY);
%symF_u = jacobian(symF,symU);

symL = 1*1e0/Nx*sum((symUe(1,:)-uf(1)).^2+(symUe(2,:)-uf(2)).^2)+1e-4/Mx*sum(symU.^2) + 1e-4/Mx*sum((symUd(1,:)-uf(1)).^2+(symUd(2,:)-uf(2)).^2);
symL_ftn = casadi.Function('symL',{t,symY,symU},{ symL });
%symPsi = 0;

symL_x = gradient(symL,symY)';
%symL_u = gradient(symL,symU)';
%symPsi_x = gradient(symPsi,symY);

symP = casadi.SX.sym('p',size(symY));

symFP = ( -symP'*symF_x - symL_x )';
%symF_x_ftn = casadi.Function('symF_x',{t,symY,symU},{ symF_x });
%symF_u_ftn = casadi.Function('symF_x',{t,symY,symU},{ symF_u });
%symL_x_ftn = casadi.Function('symL_x',{t,symY,symU},{ symL_x });
symFP_ftn = casadi.Function('symFP',{t,symP,symY,symU},{ symFP });

symH = ( symP'*symF + symL )'; 
symH_u = gradient(symH,symU);
%symH_u2 = ( symP'*symF_u + symL_u )'; 
symH_u_ftn = casadi.Function('symH_u',{t,symP,symY,symU},{ symH_u });
%symH_u2_ftn = casadi.Function('symH_u2',{t,symP,symY,symU},{ symH_u2 });

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

%GBR_figure(tline,YO_tline,UO_tline,uf);

%% Define ocp
%odeEqn.InitialCondition = Y0;

%symL = 1*1e0/Nx*sum((symUe(1,:)-uf(1)).^2+(symUe(2,:)-uf(2)).^2)+1e-4/Mx*sum(symU.^2) + 1*1e-4/Mx*sum((symUd(1,:)-uf(1)).^2+(symUd(2,:)-uf(2)).^2);
%symPsi = 0;
%PathCost = casadi.Function('symL',{t,symY,symU},{ symL });
%FinalCost = casadi.Function('symL',{symY},{ symPsi });

%iCP = ocp(odeEqn,PathCost,FinalCost);
%odeState = iCP.DynamicSystem.solver;
%odeCostate = iCP.AdjointStruct.DynamicSystem.solver;

%% Define random batch methods for states and costates
% Dynamics of one random batch
Np = 2; divides = floor(Nx/Np);
symUe_rbm = casadi.SX.sym('ue_rbm',[2,Np]);
symVe_rbm = casadi.SX.sym('ve_rbm',[2,Np]);
symX_rbm = [symUe_rbm(:);symVe_rbm(:)];
symY_rbm = symUd(:);

symL_rbm = 1*1e0/Nx*sum((symUe_rbm(1,:)-uf(1)).^2+(symUe_rbm(2,:)-uf(2)).^2)+1e-4/Mx*sum(symU.^2) + 1*1e-4/Mx*sum((symUd(1,:)-uf(1)).^2+(symUd(2,:)-uf(2)).^2);

dot_ve_rbm = - 0*symVe_rbm;
for j=1:Mx
  dot_ve_rbm = dot_ve_rbm -f_e2(square(symUd(:,j)-symUe_rbm)).*(symUd(:,j)-symUe_rbm)/2;
end
for j=1:Np
  dot_ve_rbm = dot_ve_rbm -g_e2(square(symUe_rbm(:,j)-symUe_rbm)).*(symUe_rbm(:,j)-symUe_rbm)/(Np-1);
end
for j=1:Np
  dot_ve_rbm = dot_ve_rbm +a_e2(square(symUe_rbm(:,j)-symUe_rbm)).*(symVe_rbm(:,j)-symVe_rbm)/(Np-1);
end

symF_rbm = [symVe_rbm(:)',dot_ve_rbm(:)'];
symF_rbm_ftn = casadi.Function('symF_rbm',{t,symX_rbm,symY_rbm},{ symF_rbm });

symP_rbm = casadi.SX.sym('p_rbm',[4*Np, 1]);
symF_X_rbm = jacobian(symF_rbm,symX_rbm);

symL_X_rbm = gradient(symL_rbm,symX_rbm);
symL_Y_rbm = gradient(symL,symY_rbm);

symFP_rbm = - symP_rbm'*symF_X_rbm - symL_X_rbm';
symFP_rbm_ftn = casadi.Function('symFP_rbm',{t,symP_rbm,symX_rbm,symY_rbm},{ symFP_rbm });

symPV = casadi.SX.sym('pv',[2,Nx]);
symF_Y = jacobian(dot_ve(:),symY_rbm);
symFPY = - symPV(:)'*symF_Y - symL_Y_rbm';
symFPY_ftn = casadi.Function('symFPY',{t,symPV(:),symY},{ symFPY });

% Dynamics of RBM with state
symY0 = casadi.SX.sym('y0',[4*Nx+2*Mx,1]);
symU_tline = casadi.SX.sym('Ut',[2*Mx,Nt+1]);
symY_tline = casadi.SX.sym('Yt',[4*Nx+2*Mx,Nt+1]);

% Dynamcis of RBM with costate
symP0 = casadi.SX.sym('p0',[4*Nx+2*Mx,1]);
%symYU_tline = fliplr([symY_tline;symU_tline]);
symYU_tline = ([symY_tline;symU_tline]);
symP_tline = casadi.SX.sym('Pt',[4*Nx+2*Mx,Nt+1]);

symP_tline(:,Nt+1) = symP0;
% rng(0, 'twister');
% rnglist = zeros(Nt,Nx);
% for k=Nt:-1:1
%     index = randperm(Nx);
%     rnglist(k,:) = index;
%     %index = 1:Nx;
%     for j = 1:divides
%       index_divides = index((j-1)*Np+1:j*Np);
%       index_ = [index_divides*2-1;index_divides*2];
%       index_ = index_(:);
%       index_calc = [index_;2*Nx+index_];
%       symP_tline(index_calc,k) = symP_tline(index_calc,k+1) - dt*(symFP_rbm_ftn(tline(k+1),symP_tline(index_calc,k+1),symY_tline(index_calc,k+1),symY_tline(4*Nx+1:end,k+1)))';
%     end
%     symP_tline(4*Nx+1:end,k) = symP_tline(4*Nx+1:end,k+1) - dt*(symFPY_ftn(tline(k+1),symP_tline(2*Nx+1:4*Nx,k+1),symY_tline(:,k+1)))';
% end
% odeRBMcostate = casadi.Function('odeRBMcostate',{symP0,symYU_tline},{ symP_tline });

% Dynamcis of Full batch with costate
symP_tline(:,Nt+1) = symP0;
for k=Nt:-1:1
    symP_tline(:,k) = symP_tline(:,k+1) - dt*(symFP_ftn(tline(k+1),symP_tline(:,k+1),symY_tline(:,k+1),symU_tline(:,k+1)));
end
odeFullcostate = casadi.Function('odeRBMcostate',{symP0,symYU_tline},{ symP_tline });

symY_tline(:,1) = symY0;
% for k=1:Nt
%     index = rnglist(k,:);
%     symY_tline(4*Nx+1:4*Nx+2*Mx,k+1) = symY_tline(4*Nx+1:4*Nx+2*Mx,k) + dt*(symU_tline(:,k));
%     for j = 1:divides
%       index_divides = index((j-1)*Np+1:j*Np);
%       index_ = [index_divides*2-1;index_divides*2];
%       index_ = index_(:);
%       index_calc = [index_;2*Nx+index_];
%       symY_tline(index_calc,k+1) = symY_tline(index_calc,k) + dt*(symF_rbm_ftn(tline(k),symY_tline(index_calc,k),symY_tline(4*Nx+1:4*Nx+2*Mx,k)))';
%     end
% end
% odeRBMstate = casadi.Function('odeRBMstate',{symY0,symU_tline},{ symY_tline });

% Dynamcis of Full batch with state
for k=1:Nt
    symY_tline(:,k+1) = symY_tline(:,k) + dt*(symF_ftn(tline(k),symY_tline(:,k),symU_tline(:,k)));
end
odeFullstate = casadi.Function('odeRBMstate',{symY0,symU_tline},{ symY_tline });


%%
odeState = odeFullstate;
odeCostate = odeFullcostate;
%odeState = odeRBMstate;
%odeCostate = odeRBMcostate;

%% Optimization problem with GD, open-loop.

Nt_rbm = Nt;
Np = Nx;

X = zeros(4*Np+2*Mx,Nt_rbm+1); % state
P = zeros(4*Np+2*Mx,Nt_rbm+1); % adjoint state
U = zeros(2*Mx,Nt_rbm+1); % control

DU = ones(size(U));
X0 = Y0; % initial data

X(:,1) = X0;
P(:,end) = zeros(4*Np+2*Mx,1);

tol =1e-4;
error = 1;
alpha_GD = 1e-1;


iter = 0; iter_evol=0; iter_coevol=0;
tol_alpha = 1e-15;
max_iter = 5000;
P0 = zeros(4*Np+2*Mx,1);
U = 0*U0_tline'; % initial guess for control

%
tic_total = tic;

X = odeState(X0,U); 
iter_evol = iter_evol + 1; iter_coevol = iter_coevol + 1;
error_history = zeros(max_iter,1);

while (error>tol)
    iter = iter + 1;

    P = odeCostate(P0,[X;U]); iter_coevol = iter_coevol + 1;
    
    % Gradient descent of U
    DU = full(symH_u_ftn(tline,P,X,U));

    Uold = U;
    Jold = dt*sum(full(symL_ftn(tline,X,U)));
    Jnew = Jold + 1;
    while ((Jold-Jnew)/(Jold+1e-16)<tol)&&(alpha_GD>tol_alpha)
      U = Uold - alpha_GD*DU;

      X = odeState(X0,U); iter_evol = iter_evol + 1;

      Jnew = dt*sum(full(symL_ftn(tline,X,U)));
      alpha_GD = alpha_GD * 0.5;
    end
    if (alpha_GD <= tol_alpha)
        U = Uold;

        X = odeState(X0,U); iter_evol = iter_evol + 1;
    
        Jnew = dt*sum(full(symL_ftn(tline,X,U)));
        break;
    end
    alpha_GD = alpha_GD * 2;
    U = Uold - alpha_GD*DU;

    X = odeState(X0,U); iter_evol = iter_evol + 1;

    Jnew = dt*sum(full(symL_ftn(tline,X,U)));
    alpha_GD = min(alpha_GD*2,1e2);

    error = min([norm(DU), norm(DU)/(norm(U)+1e-16)]);
    error_history(iter) = (Jold-Jnew)/(Jold+1e-16);
    if mod(iter,10)==1
        time_total = toc(tic_total);
        fprintf('Iter: %d, Evol: %d, cost: %.4e, alpha_GD: %e, time: %f\n',iter,iter_evol,Jnew,alpha_GD,time_total);
    end
    if iter == max_iter;
        break
    end
end
time_total = toc(tic_total);
fprintf('Total elapsed time: %.6e \n',time_total);
fprintf('Iteration: %d, cost: %.4e, error: %.4e, time: %f\n',iter,Jnew,error,time_total);
UO_tline = full(U)';
%%
Ufull_tline = UO_tline;
Ufull_time = time_total;
Ufull_iter = iter;
Ufull_evol = iter_evol;
Ufull_coevol= iter_coevol;

%% Post-processing of the total trajectories
% Cost calcultaion
UO_tline = UO_tline;
YO_tline = full(odeFullstate(Y0,UO_tline')');
GBR_figure(tline,YO_tline,UO_tline,uf);


%%

function [] = GBR_figure(tline,YO_tline,UO_tline,uf)
    [TN, Mx] = size(UO_tline);
    [~, NN] = size(YO_tline);
    Mx = Mx/2;
    Nx = (NN - 2*Mx)/4;
    %uf = [1;1];

    %TN = length(tline); 
    dt = tline(2)-tline(1); tline = 0:dt:dt*(TN-1);
    ue_tline = reshape(YO_tline(:,1:2*Nx),[TN 2 Nx]);
    %ve_tline = reshape(YO_tline(:,2*Nx+1:4*Nx),[TN 2 Nx]);
    ud_tline = reshape(YO_tline(:,4*Nx+1:4*Nx+2*Mx),[TN 2 Mx]);
    vd_tline = reshape(UO_tline,[TN 2 Mx]);
    %Final_Position = reshape(ue_tline(end,:,:),[2 Nx]);
    
    % 1*dt/Np*sum(sum((X_ue(1:Nt_rbm+1,:)-uf(1)).^2+(X_ue(Nt_rbm+2:end,:)-uf(2)).^2))+10*dt/Mx*sum(U(:).^2)
    Final_Psi = 1*dt/Nx*sum(sum((ue_tline(:,1,:)-uf(1)).^2+(ue_tline(:,2,:)-uf(2)).^2,1),3);%+10*dt/Mx*sum(vd_tline(:).^2);
    %Final_Psi = mean( (Final_Position(1,:) - uf(1)).^2+(Final_Position(2,:) - uf(2)).^2 );

    Final_Reg = trapz(tline,mean(UO_tline.^2,2));
    Final_Reg2= 1*dt/Mx*sum(sum((ud_tline(:,1,:)-uf(1)).^2+(ud_tline(:,2,:)-uf(2)).^2,1),3);%+10*dt/Mx*sum(vd_tline(:).^2);

    figure('position', [0, 0, 1000, 400]);

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
    legend('(1,1)-directional velocity','(1,-1)-directional velocity')
    xlabel('Time')
    ylabel('Controls')
    %title(['Total Time = ',num2str(tline(end)),' and running cost = ',num2str(Final_Reg)])
    title(['Control cost = ',num2str(Final_Reg+Final_Reg2)])
    set(gca,'fontsize', 18);
    grid on

end