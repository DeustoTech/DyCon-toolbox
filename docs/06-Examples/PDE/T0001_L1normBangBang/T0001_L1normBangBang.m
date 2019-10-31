
%% Discretization of the problem
% As a first thing, we need to discretize \eqref{frac_heat}. 
% Hence, let us consider a uniform N-points mesh on the interval $(-1,1)$.


Nx = 70;
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
M  = MassMatrix(xline);
%M  = speye(Nx);
%%
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "construction_matrix_B" (see below).
a = -0.3; b = 0.8;
B = BInterior(xline,a,b,'mass',true,'min',true);
B = sparse(B);
%%
% We can then define a final time and an initial datum
Y0 = 0.5*cos(0.5*pi*xline.');

Nt = 70;
FinalTime = 0.2;
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'Nt',Nt);
dynamics.Solver = @euleri;
dynamics.MassMatrix = M;
dynamics.mesh{1} = xline;

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
beta = dx^4;
%% Construction of the control problem 
%%
% $ \frac{1}{2 \epsilon} || Y - YT || ^2 + \int_0^T ||U||dt $
%%
Psi  = @(T,Y)   (1/beta)*dx*(YT - Y).'*(YT - Y);
L    = @(t,Y,U) dx*sum(abs(U));
%L    = 0.5*beta*dx*(U.'*U);
%%
% Optional Parameters to go faster
%%
% Optional Parameters to go faster
L_u   = @(t,Y,U) dx*sign(U);
L_y   = @(t,Y,U) zeros(1,dynamics.StateDimension)';
Psi_y = @(t,Y)   (2/(beta))*dx*(Y - YT).';

Adjoint = pde('A',A.');

OCParmaters = {'DiffLagrangeState'    , L_y    ,'DiffLagrangeControl'  ,L_u, ...
               'DiffFinalCostState'   , Psi_y  ,'Adjoint',Adjoint,'CheckDerivatives',false};
%%
% build problem with constraints
iOCP =  Pontryagin(dynamics,Psi,L,OCParmaters{:});
iOCP.Target = YT;
%iOCP.constraints.Umax =  300;
iOCP.Constraints.MinControl =  0;

    % Solver L1
Parameters = {'DescentAlgorithm',@ConjugateDescent, ...
             'tol',1,                                    ...
             'Graphs',false,                               ...
             'MaxIter',5000,                               ...
             'EachIter',50, ...
             'display','functional',};
%%
U0 = zeros(length(iOCP.Dynamics.tspan),iOCP.Dynamics.ControlDimension) + 1e-3;
%
JOpt = GradientMethod(iOCP,U0,Parameters{:});
%
animation(iOCP.Dynamics,'xx',0.01,'Target',YT,'YLim',[0 7],'YLimControl',[0 3000])
%% References
% 
% [1] U. Biccari and V. Hern\'andez-Santamar\'ia - \textit{Controllability 
%     of a one-dimensional fractional heat equation: theoretical and 
%     numerical aspects}, IMA J. Math. Control. Inf., to appear 
