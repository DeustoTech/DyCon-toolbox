% Time Parameters 
clear
FinalTime = 0.1;
Nt = 1500;
% Space Parameters 
Nx = 20;
xi = -1; xf = 1;
% mesh
xline = linspace(xi,xf,Nx);
yline = linspace(xi,xf,Nx);
%
[xms, yms] = meshgrid(xline,yline);

dx = xline(2)-xline(1);
dy = yline(2)-yline(1);

%% Dynamics Matrix 
A = FDLaplacial2D(xline,yline);
A = [A zeros(Nx*Nx,2)];
A = [A;  zeros(2,Nx*Nx+2)];
%%
SizeInX = 0.15;
SizeInY = 0.15;


%%
Ys = sym('y',[1 Nx*Nx + 2]);
Us = sym('u',[1 Nx*Nx + 2]);

BFcn = @(x,y) BFcnTotal(xline,yline,x,y,SizeInX,SizeInY);

F  = @(t,Y,U,Params) A*Y + BFcn(Y(end-1),Y(end))*U;
%%
alpha = 0.5;
Y0 = 0.1*exp(-(xms.^2 + yms.^2)/alpha.^2);
Y0 = Y0(:)';
% Add two additional variables - position of obj
Y0 = [Y0 0.2 0.2]';
%%
dynamics = pde(F,Ys,Us);
dynamics.mesh = {xline,yline};
dynamics.InitialCondition = Y0;
dynamics.FinalTime =FinalTime;
dynamics.Nt = Nt;
dynamics.Solver = @eulere;
U0 = dynamics.Control.Numeric*0 + 200;

tspan = dynamics.tspan;
VV = 150;
nn = 10;
uxmove = VV*cos(2*pi*nn*tspan/0.1) - VV*tspan;
uymove = VV*sin(2*pi*nn*tspan/0.1) - VV*tspan;

U0(:,end-1) = uxmove;
U0(:,end) = uymove;

[~ ,YT] = solve(dynamics,'Control',U0);
%%
animation2DMovil(dynamics)
%%

function B = BFcnTotal(xline,yline,x,y,SizeInX,SizeInY)
    B = BObstacle2D(xline,yline,x,y,SizeInX,SizeInY);
    Nx = length(xline);
    B = [B zeros(Nx*Nx,2)];
    B = [B;  zeros(2,Nx*Nx+2)];
    B(end,end) = 1;
    B(end-1,end-1)  = 1;
end


