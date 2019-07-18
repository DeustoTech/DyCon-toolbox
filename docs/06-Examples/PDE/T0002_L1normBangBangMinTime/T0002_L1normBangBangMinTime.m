
%%
FinalTime = 0.2;
Nx = 50;
xi = -1; xf = 1;
xline = linspace(xi,xf,Nx);
xline = linspace(0,1,Nx+2);
xline = xline(2:end-1);
dx = xline(2)-xline(1);
%%
% Out of that, we can construct the FE approxiamtion of the fractional
% Lapalcian, using the program FEFractionalLaplacian developped by our
% team, which implements the methodology described in [1].
%%
s = 0.8;
A  = -FEFractionalLaplacian(s,1,Nx);
M  = MassMatrix(xline);
%%
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "construction_matrix_B" (see below).
a = -0.3; b = 0.8;
B = BInterior(xline,a,b,'mass',false,'min',true);
B = sparse(B);
%%
% We can then define a final time and an initial datum
Y0 = 0.5*cos(0.5*pi*xline');

Nt = 50;
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'Nt',Nt);
dynamics.Solver = @euleri;
dynamics.MassMatrix = M;
dynamics.mesh = xline;

%% Calculate the Target
Y0_other = 6*cos(0.5*pi*xline);
TargetDynamics = copy(dynamics);
TargetDynamics.InitialCondition = Y0_other';
U00 = TargetDynamics.Control.Numeric*0 + 1;
[~ ,YT] = solve(TargetDynamics,'Control',U00);

YT = YT(end,:).';


%% Construction of the control problem 

Psi  = @(T,Y) dx*(YT - Y).'*(YT - Y);
L    = @(t,Y,U) 1 ;
%
% build problem with constraints
iOCP =  Pontryagin(dynamics,Psi,L,'SymbolicCalculations',false);
iOCP.Target = YT;
%iOCP.constraints.Umax =  300;
iOCP.Constraints.MinControl =  0;

%
AMPLFile(iOCP,'Umberto.txt','FixedTime',false)
                                    %%
out = SendNeosServer('Umberto.txt');
data = NeosLoadData(out);

