clear;
Ns = 30;
Nt = 100;
xline = linspace(-1,1,Ns);
yline = linspace(-1,1,Ns);



A = FDLaplacial2D(xline,yline);
B = BInterior2D(xline,yline,-0.25,0.25,-0.25,0.25);

[xms,yms] = meshgrid(xline,yline);


tspan = linspace(0,11,Nt);

idynamics = pde('A',A,'B',B);
alpha = 0.5;
Y0 = 10*exp(-xms.^2/alpha^2  - yms.^2/alpha^2);
idynamics.InitialCondition = Y0(:);
idynamics.Nt = Nt;
idynamics.FinalTime = 0.1;
idynamics.mesh{1} = xline;
U = 0*ones(Nt,Ns^2);
[t,YControl] = solve(idynamics,'Control',U);
%%
R = 1e-4*eye(Ns^2); Q = 1e5*eye(Ns^2);
[ricsol, cleig, K, report ]= care(A, B, Q, R);
%%
idynamicsControl = copy(idynamics);
idynamicsControl.A =  A-K;

[~ , YtC] = solve(idynamicsControl)
%%
xlinef = linspace(xline(1),xline(end),4*Ns);
ylinef = linspace(yline(1),yline(end),4*Ns);

[xmsf ymsf] = meshgrid(xlinef,ylinef);

%%
close all
Wt = YtC
figure('unit','norm','pos',[0 0 1 1],'Color','k')
Z = reshape(Wt(1,1:Ns^2),Ns,Ns);
isurf = surf(xmsf,ymsf, interp2(xms,yms,Z,xmsf,ymsf,'spline'));
hold on
isurf.Parent.Color = 'k';
shading interp
isurf.LineStyle = 'none';
lighting gouraud
lightangle(40,40)
axis(isurf.Parent,'off')
colormap   
zlim([-15 15])
caxis([-10 10])
az = 50;
el = 60;
view(az,el)
daspect([1 1 10])
colormap jet
%%


x = 0;
y = 0;
z = 12;
radius = 0.1;
% Create the mesh of shere
[Xs,Ys,Zs] = sphere;
X = (Xs+x)*radius; Y = (Ys+y)*radius; Z = 4.5 + 6*(Zs+z)*radius;
jsurf = surf(X,Y,Z);
jsurf.CData = jsurf.CData*0 ;
jsurf.LineStyle = 'none';
%%
%% Show Initial Condition
for it = 1:150
   Z = reshape(Wt(1,1:Ns^2),Ns,Ns);
   isurf.ZData =  interp2(xms,yms,Z,xmsf,ymsf,'spline');
   az = az + 0.1;
   el = el - 0.2;
   view(az,el)
   pause(0.03)
end
%%
Control = (-K*YtC')';
normControl = arrayfun(@(id) norm(Control(id,:)),1:Nt);
maxC = max(normControl);
minC = min(normControl);
dC = maxC - minC;
normControl = (normControl - minC)/dC;
for it = 1:Nt
   Z = reshape(Wt(it,1:Ns^2),Ns,Ns);

   isurf.ZData =  interp2(xms,yms,Z,xmsf,ymsf,'spline');
   jsurf.CData = jsurf.CData*0  +normControl(it)*10;
   az = az + 0.1;
   view(az,el)
   pause(0.05)
end
%%
for it = 1:150
   Z = reshape(Wt(end,1:Ns^2),Ns,Ns);
   isurf.ZData =  interp2(xms,yms,Z,xmsf,ymsf,'spline');
   jsurf.CData = jsurf.CData*0;

   az = az + 0.1;
   view(az,el)
   pause(0.03)
end