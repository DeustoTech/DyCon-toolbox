
%% Discretization of the problem
% As a first thing, we need to discretize \eqref{frac_heat}. 
% Hence, let us consider a uniform N-points mesh on the interval $(-1,1)$.

FinalTimes = linspace(0.05,0.5,4);
%FinalTimes = linspace(1.05,1.1,4);
%FinalTimes = 0.1652;
iOCPs = arrayfun(@(FinalTime) FinalTime2OCP(FinalTime),FinalTimes);

ncol = 3;
nft  = length(FinalTimes);

figure;

iter = 0;
for iOCP = iOCPs
    iter = iter + 1;
    subplot(ceil(nft/ncol),ncol,iter)
    surf(iOCP.solution.UOptimal)
    title("T_f = "+FinalTimes(iter)+ "& |.| = "+sqrt(iOCP.solution.JOptimal))
    shading interp;colormap jet
    %caxis([0 40])
    colorbar
    view(0,90)
end

solutions = [iOCPs.solution];
distance =  sqrt([solutions.JOptimal])

Tmin = interp1(distance,FinalTimes,5e-2)


iOCP_MinTime = FinalTime2OCP(Tmin)

figure
surf(iOCP_MinTime.solution.UOptimal)
title("T_f = "+Tmin+ "& |.| = "+sqrt(iOCP_MinTime.solution.JOptimal))
shading interp;colormap jet
%caxis([0 40])
colorbar
view(0,90)
    
function iOCP = FinalTime2OCP(FinalTime)
    Nx = 50;
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
    A = -FEFractionalLaplacian(s,1,Nx);
    %A = FDLaplacian(xline);
    %A(1,2) = 2*Nx^2;
    %A(end,end-1) = 2*Nx^2;
    M = massmatrix(xline);
    %M = eye(Nx);
    %%
    % Moreover, we build the matrix $B$ defining the action of the control, by
    % using the program "construction_matrix_B" (see below).
    a = -0.3; b = 0.8;
    B = construction_matrix_B(xline,a,b);
    %B = B*0;
    %B(1,1) = 2*Nx;
    %B(end,end) = 2*Nx;
    
    %%
    % We can then define a final time and an initial datum
    Y0 = 0.5*cos(0.5*pi*xline');
    %Y0 = 0*xline' + 5;
    %Y0 = 0*xline' + 1;
    Nt = 50;
    dt = FinalTime/Nt;
    dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
    dynamics.MassMatrix = M;
    dynamics.mesh = xline;

    %% Calculate the Target
    Y0_other = 3*cos(0.5*pi*xline');
    TargetDynamics = copy(dynamics);
    TargetDynamics.InitialCondition = Y0_other;
    U00 = TargetDynamics.Control.Numeric*0 + 0.5;
    %U00 = cos(3*pi*xline')*cos(20*pi*dynamics.tspan);
    [~ ,YT] = solve(TargetDynamics,'Control',U00');
    
    YT = YT(end,:).';
    %YT = 0*xline' + 1;
    %YT = 0*xline' + 5;

    %% 
    % Take simbolic vars
    Y = dynamics.StateVector.Symbolic;
    U = dynamics.Control.Symbolic;
    beta = 0;
    %% Construction of the control problem 
    %%
    % $ \frac{1}{2 \epsilon} || Y - YT || ^2 + \int_0^T ||U||dt $
    %%
    Psi  = dx*(YT - Y).'*(YT - Y);
    L    = beta*dx*sum(abs(U));
    %%
    % Optional Parameters to go faster
    Gradient                =  @(t,Y,P,U) beta*dx*sign(U) + B*P;
    Hessian                 =  @(t,Y,P,U) 0;
    AdjointFinalCondition   =  @(t,Y) (dx/(2))* (Y-YT);
    Adjoint = pde('A',A);
    OCParmaters = {'Hessian',Hessian,'ControlGradient',Gradient,'AdjointFinalCondition',AdjointFinalCondition,'Adjoint',Adjoint};
    %%
    % build problem with constraints
    iOCP =  Pontryagin(dynamics,Psi,L,OCParmaters{:});
    %iOCP.constraints.Umax =  50;
    iOCP.constraints.Umin =  0;

    %%
    % Solver L1
    Parameters = {'DescentAlgorithm',@ConjugateDescent, ...
                 'tol',1e-9,                                    ...
                 'Graphs',false,                               ...
                 'MaxIter',5000,                               ...
                 'display','all',};
    %%
    GradientMethod(iOCP,Parameters{:})
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
