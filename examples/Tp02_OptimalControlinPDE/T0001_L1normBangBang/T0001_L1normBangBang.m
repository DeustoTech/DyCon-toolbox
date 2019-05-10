
%% Discretization of the problem
% As a first thing, we need to discretize \eqref{frac_heat}. 
% Hence, let us consider a uniform N-points mesh on the interval $(-1,1)$.

FinalTimes = linspace(0.05,0.5,3);
%FinalTimes = linspace(0.7,1.0,4);
FinalTimes = 0.2;
%FinalTimes = 0.1531;
%FinalTimes = 0.0438;
%FinalTimes = linspace(0.03,0.05,2);

iOCPs = arrayfun(@(FinalTime) FinalTime2OCP(FinalTime),FinalTimes);

ncol = 3;
nft  = length(FinalTimes);

figure;

iter = 0;
for iOCP = iOCPs
    iter = iter + 1;
    subplot(ceil(nft/ncol),ncol,iter)
    surf(iOCP.Solution.UOptimal)
    title("T_f = "+FinalTimes(iter)+ "& |.| = "+sqrt(iOCP.Solution.JOptimal))
    shading interp;colormap jet
    %caxis([0 40])
    colorbar
    view(0,90)
end

solutions = [iOCPs.Solution];
distance =  sqrt([solutions.JOptimal])

Tmin = interp1(distance,FinalTimes,5e-2)


iOCP_MinTime = FinalTime2OCP(Tmin)

figure
surf(iOCP_MinTime.Solution.UOptimal)
title("T_f = "+Tmin+ "& |.| = "+sqrt(iOCP_MinTime.Solution.JOptimal))
shading interp;colormap jet
%caxis([0 40])
colorbar
view(0,90)
    
function iOCP = FinalTime2OCP(FinalTime)
    Nx = 20;
    xi = -1; xf = 1;
    xline = linspace(xi,xf,Nx+2);
    %xline = linspace(0,1,Nx+2);
    xline = xline(2:end-1);
    dx = xline(2)-xline(1);
    %%
    % Out of that, we can construct the FE approxiamtion of the fractional
    % Lapalcian, using the program FEFractionalLaplacian developped by our
    % team, which implements the methodology described in [1].
    %%
    s = 0.8;
    A  = -FEFractionalLaplacian(s,1,Nx);
    M  = massmatrix(xline);
    %%
    % Moreover, we build the matrix $B$ defining the action of the control, by
    % using the program "construction_matrix_B" (see below).
    a = -0.3; b = 0.8;
    B = construction_matrix_B(xline,a,b);
    
    %%
    % We can then define a final time and an initial datum
    Y0 = 0.5*cos(0.5*pi*xline');

    Nt = 100;
    dt = FinalTime/Nt;
    dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
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
    beta = dx^2;
    %% Construction of the control problem 
    %%
    % $ \frac{1}{2 \epsilon} || Y - YT || ^2 + \int_0^T ||U||dt $
    %%
    Psi  = dx*(YT - Y).'*(YT - Y);
    L    = beta*dx*sum(abs(U));
    %L    = 0.5*beta*dx*(U.'*U);
    %%
    % Optional Parameters to go faster
    Gradient                =  @(t,Y,P,U) beta*sign(U) + B*P;
    %Gradient                =  @(t,Y,P,U) beta*U + B*P;
    Hessian                 =  @(t,Y,P,U) 0;
    AdjointFinalCondition   =  @(t,Y) (1/2)* (Y-YT);
    Adjoint = pde('A',A);
    OCParmaters = {'Hessian',Hessian,'ControlGradient',Gradient,'AdjointFinalCondition',AdjointFinalCondition,'Adjoint',Adjoint};
    %%
    % build problem with constraints
    iOCP =  Pontryagin(dynamics,Psi,L,OCParmaters{:});
    iOCP.Target = YT;
    %iOCP.constraints.Umax =  300;
    iOCP.Constraints.MinControl =  0;

    %options = optimoptions(@fmincon,'display','iter','SpecifyObjectiveGradient',true)
    %fmincon(@(U) Control2Functional(iOCP,U),0*U00,[],[],[],[],0*U00,[],[],options)
    %%
    % Solver L1
    Parameters = {'DescentAlgorithm',@ConjugateDescent, ...
                 'tol',1e-8,                                    ...
                 'Graphs',true,                               ...
                 'MaxIter',5000,                               ...
                 'display','functional',};
    %%
    U0 = zeros(length(iOCP.Dynamics.tspan),iOCP.Dynamics.Udim);
    GradientMethod(iOCP,U0,Parameters{:})
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
