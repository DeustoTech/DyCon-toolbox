%%
Nx = 100;
xline = linspace(-1,1,Nx+2);
xline = xline(2:end-1);
dx    = xline(2) - xline(1);
%%
A = -FEFractionalLaplacian(0.8,1,Nx);
B =  BInterior(xline,-0.3,0.8,'Mass',true);
%%
idyn            = pde('A',A,'B',B);
idyn.FinalTime  = 0.5;
idyn.Nt         = 100;
idyn.mesh{1}    = xline;
idyn.MassMatrix = MassMatrix(xline);
%
idyn.InitialCondition = sin(pi*xline');
%%
iHUM = HUM(idyn);
iHUM.Epsilon = dx^4;
%%
f0   = zeros(Nx,1);
fOpt = CoConjugateGradient(iHUM,f0,'tol',1e-8);

%%
close all
subplot(1,2,1)
surf(iHUM.Dynamics.Control.Numeric)
shading interp
subplot(1,2,2)
surf(iHUM.Dynamics.StateVector.Numeric)
shading interp

%%


solve(idyn);
%%
iHUM.Dynamics.label = 'dynamics';
idyn.label = 'Free';

xx = idyn.FinalTime/5;
%%
% ```
%
% animation([iHUM.Dynamics idyn],'xx',xx,'YLim',[-0.2 0.2],'YLimControl',[-100 100])
%
% ```
%%
% ![](extra-data/090579.gif)
