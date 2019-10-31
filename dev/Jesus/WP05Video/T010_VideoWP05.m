clear;

memory = 1;

Ns = 50;
Nt = 400;
xline = linspace(-1.5,1.5,Ns);
yline = linspace(-1.5,1.5,Ns);

Lap = FDLaplacial2D(xline,yline);

A = [Lap memory*eye(Ns^2); memory*30*eye(Ns^2) 0*eye(Ns^2) ]

[xms,yms] = meshgrid(xline,yline);

alpha = 0.2;
alphamid = 0.3;
gs = @(x,y,x0,y0,alpha) exp(-(x-x0).^2/alpha^2  - (y-y0).^2/alpha^2)
U0 = + 10*gs(xms,yms,+0.65,+0.65,alpha) ...
     + 10*gs(xms,yms,+0.65,-0.65,alpha) ...
     + 10*gs(xms,yms,-0.65,-0.65,alpha) ...
     + 10*gs(xms,yms,-0.65,+0.65,alpha) ...
     - 11.25*gs(xms,yms,0,0,alphamid) ;
U0 = U0(:)
W0 = [U0;U0*0];

tspan = linspace(0,1.4,Nt);
[~ , Wt] = ode45(@(t,W) A*W,tspan,W0);
%%
xlinef = linspace(xline(1),xline(end),4*Ns);
ylinef = linspace(yline(1),yline(end),4*Ns);

[xmsf ymsf] = meshgrid(xlinef,ylinef);

%%
close all
figure('unit','norm','pos',[0 0 1 1],'Color','k')
Z = reshape(Wt(1,1:Ns^2),Ns,Ns);
isurf = surf( interp2(xms,yms,Z,xmsf,ymsf,'spline'));
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
el = 9;
view(az,el)
daspect([1 1 0.5])
%% Show Initial Condition
for it = 1:150
   Z = reshape(Wt(1,1:Ns^2),Ns,Ns);
   isurf.ZData =  interp2(xms,yms,Z,xmsf,ymsf,'spline');
   az = az + 0.05;
   view(az,el)
   pause(0.03)
end
%%
for it = 1:Nt
   Z = reshape(Wt(it,1:Ns^2),Ns,Ns);

   isurf.ZData =  interp2(xms,yms,Z,xmsf,ymsf,'spline');
   az = az + 0.05;
   view(az,el)
   pause(0.05)
end
%%
for it = 1:150
   Z = reshape(Wt(end,1:Ns^2),Ns,Ns);
   isurf.ZData =  interp2(xms,yms,Z,xmsf,ymsf,'spline');
   az = az + 0.05;
   view(az,el)
   pause(0.03)
end
