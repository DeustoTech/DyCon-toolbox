clear all
import casadi.*

Nx = 100;
T = 2;
L = 5.0;
xmesh = linspace(-L,L,Nx);

Ys = SX.sym('x',Nx,1);
Us = SX.sym('u',Nx,1);
ts = SX.sym('t');

A = FDLaplacian(xmesh);
% add Neumann
A(1,2)       = 2*A(1,2);
A(end,end-1) = 2*A(end,end-1);
% Need some Matrix control
B = BInterior(xmesh,-0.5,0.5);
%
Theta = 1/3;
NonLinearTerm = Function('NLT',{Ys},{Ys.*(1-Ys).*(Ys-Theta)});
%%
thfcn = @(x) 0.5 + 0.5*tanh(1e5*x);
Y0 = thfcn(xmesh'-0.75*L);
%%
Nt = 100;
old_tspan = linspace(0,T,Nt);
tspan = old_tspan(1:3);
%
F_reaction = casadi.Function('F',{ts,Ys,Us},{ B*Us + 10*NonLinearTerm(Ys)});
isys_reaction = pde1d(F_reaction,Ys,Us,tspan,xmesh);
SetIntegrator(isys_reaction,'RK8')
%%
isys_diff = linearpde1d(A,B,tspan,xmesh);
%%

isys_diff.InitialCondition = Y0;
u0 = ZerosControl(isys_reaction);
Sol = solve(isys_diff,u0);

Sol_total = casadi.DM(Nx,Nt);

figure(1)
clf
iplot = plot(xmesh,Y0,'r','LineWidth',2);
hold on
plot(xmesh,xmesh*0 + Theta,'b','LineWidth',2)
legend({'u(t)','\theta'},'Location','bestoutside')
xlabel('space')
ylabel('u(t)')
ylim([-L L])
ylim([0 1])
ititle = title('{\color{red}[REACTION]}<-> [DIFFUSION]');

s = '$u_t = u_{xx}  + u(1-u)(u-\theta) $ ';

ian = annotation('textbox',[0.15 0.15 0.385 0.0775],'String',s,'Interpreter','latex','LineWidth',0.1,'FontSize',18);
%
pause(1)

for it = 1:Nt
    
    isys_diff.InitialCondition = Sol(:,end);
    Sol = solve(isys_diff,u0);
    
    % update reaction
    ititle.String = ['{\color{red}[REACTION]}<-> [DIFFUSION]'];
    iplot.YData = full(Sol(:,end-2));
    pause(0.05)

    %
    isys_reaction.InitialCondition = Sol(:,end);
    Sol = solve(isys_reaction,u0);
    % update reaction
    ititle.String = ['[REACTION]<-> {\color{red}[DIFFUSION]}'];
    iplot.YData = full(Sol(:,end-2));
    pause(0.05)
    
    Sol_total(:,it) = Sol(:,end-2);
end

%%
pause(1)
figure(1)
clf
[xms,tms] = meshgrid(old_tspan,xmesh);
surf(tms,xms,full(Sol_total))
colormap jet
colorbar
view(0,90)
shading interp
xlabel('space')
ylabel('time')

