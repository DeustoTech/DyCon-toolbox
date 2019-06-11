
%% Discretization of the problem
% As a first thing, we need to discretize \eqref{frac_heat}. 
% Hence, let us consider a uniform N-points mesh on the interval $(-1,1)$.

%FinalTimes = linspace(0.1,0.25,4);
%FinalTimes = linspace(0.1,0.3,4);
FinalTimes = 0.08;
%FinalTimes = 0.15;
%FinalTimes = 0.0438;
%FinalTimes = linspace(0.03,0.05,2);

% iOCPs = arrayfun(@(FinalTime) FinalTime2OCP(FinalTime),FinalTimes);
% 
% ncol = 3;
% nft  = length(FinalTimes);
% %%
% figure;
% 
% iter = 0;
% dx =  iOCPs(1).Dynamics.mesh(2) - iOCPs(1).Dynamics.mesh(1);
% distance = dx*TargetDistance(iOCPs);
% for iOCP = iOCPs
%     iter = iter + 1;
%     subplot(ceil(nft/ncol),ncol,iter)
%     surf(iOCP.Dynamics.Control.Numeric)
%     title("T_f = "+FinalTimes(iter)+ "& |.| = "+distance(iter))
%     %title("T_f = "+FinalTimes(iter))
% 
%     shading interp;colormap jet
%     %caxis([0 40])
%     colorbar
%     view(0,90)
% end
%%


Tmin = 0.21


iOCP_MinTime = FinalTime2OCP(Tmin)
%%
figure
surf(iOCP_MinTime.Solution.UOptimal)
dx =  iOCP_MinTime.Dynamics.mesh(2) - iOCP_MinTime.Dynamics.mesh(1);
title("T_f = "+Tmin+ "& |.| = "+ dx*TargetDistance(iOCP_MinTime));
%shading interp;colormap jet
%caxis([0 40])
colorbar
view(0,90)
    
%%
animation(iOCP_MinTime.Dynamics,'xx',0.05,'YLim',[0 7],'Target',iOCP_MinTime.Target,'YLimControl',[0 1e4])
%%
function iOCP = FinalTime2OCP(FinalTime)
    Nx = 25;
    xi = -1; xf = 1;
    xline = linspace(xi,xf,Nx);
    %xline = linspace(0,1,Nx+2);
%     xline = xline(2:end-1);
     dx = xline(2)-xline(1);
    %%
    % Out of that, we can construct the FE approxiamtion of the fractional
    % Lapalcian, using the program FEFractionalLaplacian developped by our
    % team, which implements the methodology described in [1].
    %%
    s = 0.8;
    A  = -FEFractionalLaplacian(s,1,Nx);
    %A = FDLaplacian(xline);
    %A = sparse(A);
    M  = massmatrix(xline);
    %M  = speye(Nx);
    %%
    % Moreover, we build the matrix $B$ defining the action of the control, by
    % using the program "construction_matrix_B" (see below).
    a = -0.3; b = 0.8;
    B = BInterior(xline,a,b,'mass',false);
    B = sparse(B);
    %%
    % We can then define a final time and an initial datum
    Y0 = 0.5*cos(0.5*pi*xline');

    Nt = 25;
    dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'Nt',Nt);
    dynamics.Solver = @euleri;
    dynamics.MassMatrix = M;
    dynamics.mesh = xline;

    %% Calculate the Target
    Y0_other = 6*cos(0.5*pi*xline');
    TargetDynamics = copy(dynamics);
    TargetDynamics.InitialCondition = Y0_other;
    U00 = TargetDynamics.Control.Numeric*0 + 1;
    %U00 = cos(3*pi*xline')*cos(20*pi*dynamics.tspan);
    [~ ,YT] = solve(TargetDynamics,'Control',U00);
    
    YT = YT(end,:).';

    %% 
    % Take simbolic vars
    Y = dynamics.StateVector.Symbolic;
    U = dynamics.Control.Symbolic;
    beta = dx^4;
    %% Construction of the control problem 
    %%
    % $ \frac{1}{2 \epsilon} || Y - YT || ^2 + \int_0^T ||U||dt $
    %%
    Psi  = (1/beta)*dx*(YT - Y).'*(YT - Y);
    L    = 0*dx*sum(abs(U));
    %L    = 0.5*beta*dx*(U.'*U);
    %%
    % Optional Parameters to go faster
    Gradient                =  @(t,Y,P,U) dynamics.dt*(0*sign(U) + B'*P);
    %Gradient                =  @(t,Y,P,U) beta*U + B*P;
    Hessian                 =  @(t,Y,P,U) 0;
    AdjointFinalCondition   =  @(t,Y) (1/(2*beta))*(Y-YT);
    Adjoint = pde('A',A);
    OCParmaters = {'Hessian',Hessian,'ControlGradient',Gradient,'AdjointFinalCondition',AdjointFinalCondition,'Adjoint',Adjoint};
    %%
    % build problem with constraints
    iOCP =  Pontryagin(dynamics,Psi,L,OCParmaters{:});
    iOCP.Target = YT;
    %iOCP.constraints.Umax =  300;
    iOCP.Constraints.MinControl =  0;

        % Solver L1
    Parameters = {'DescentAlgorithm',@ConjugateDescent, ...
                 'tol',1e-8,                                    ...
                 'Graphs',false,                               ...
                 'MaxIter',5000,                               ...
                 'EachIter',50, ...
                 'display','functional',};
    %%
    U0 = zeros(length(iOCP.Dynamics.tspan),iOCP.Dynamics.Udim) + 1e-3;
    %load('UO.mat')
    JOpt = GradientMethod(iOCP,U0,Parameters{:});
%     options = optimoptions(@fmincon,              'display','iter'  , ...
%                                  'SpecifyObjectiveGradient',true    , ...                                               'Algorithm','trust-region-reflective',...
%                                                'CheckGradients',false, ...
%                                                'UseParallel',true );
%     %U0 = zeros(length(iOCP.Dynamics.tspan),iOCP.Dynamics.Udim);
%     
%     U0 = iOCP.Solution.UOptimal;
%     [Uopt , JOpt] = fmincon(@(U) Control2Functional(iOCP,U),U0, ...
%                                             []    ,  [] , ... % eq constraints
%                                             []    ,  [] , ... % ieq cons
%                                             U0*0-1e-8 ,   [] , ...
%                                             []          , ...
%                                             options);
    
    %iOCP.Solution = solution;
    %iOCP.Solution.Jhistory = JOpt;
                                        %%

end
%%
function [B] = construction_matrix_B(mesh,a,b)

N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);

end
function M = massmatrix(mesh)
    N = length(mesh);
    dx = mesh(2)-mesh(1);
    M = 2/3*eye(N);
    for i=2:N-1
        M(i,i+1)=1/6;
        M(i,i-1)=1/6;
    end
    M(1,2)=1/6;
    M(N,N-1)=1/6;
            
    M=dx*sparse(M);
end
%% References
% 
% [1] U. Biccari and V. Hern\'andez-Santamar\'ia - \textit{Controllability 
%     of a one-dimensional fractional heat equation: theoretical and 
%     numerical aspects}, IMA J. Math. Control. Inf., to appear 
