%%
clear all
load('WP05RumbaFinal.mat')
%%
Xnum_with_control = Xnum_free;
%
xl = xline;
yl = yline;
xline_fine = linspace(xl(1),xl(end),4*length(xl));
yline_fine = linspace(yl(1),yl(end),4*length(yl));
[xms_fine,yms_fine] = meshgrid(xline_fine,yline_fine);
%%
%%
fig = figure('unit','norm','pos',[0 0 1 1],'Color','k');
ax1 = axes('Parent',fig);

Z = reshape(Xnum_with_control(1:end-4,1),Ns,Ns);
isurf = surf(xms_fine,yms_fine,interp2(xms,yms,Z,xms_fine,yms_fine,'spline'),'Parent',ax1);
hold on
%
%
x = Xnum_with_control(end-3,1);
y = Xnum_with_control(end-2,1);
z = 3 + 50;
radius = 0.1;
% Create the mesh of shere
[Xs,Ys,Zs] = sphere;
X = (Xs)*radius + x; Y = (Ys)*radius + y; Z = z + Zs*radius;
jsurf = surf(X,Y,Z);
jsurf.CData = jsurf.CData*0 + 100 ;
%%
axis(ax1,'off')
zlim(ax1,[-0.2 4])
caxis(ax1,[0 1])
shading(ax1,'interp')
lightangle(ax1,40,40)
lighting(ax1,'gouraud')
colormap jet
daspect([1 1 4])
%%
az = 130;
el = 15;
view(ax1,az,el)

%% Show 
for it = 1:100;
    az = az + 0.15;
    view(az,el)
    pause(0.08)   
end

for it = 1:length(tspan_fine)
    % controled state
    Z = reshape(Xnum_with_control(1:end-4,it),Ns,Ns);
    isurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'spline');
    %
    xdrone = Xnum_with_control(end-3,it);
    ydrone = Xnum_with_control(end-2,it);
    %
    X = (Xs)*radius+xdrone; Y = (Ys)*radius+ydrone;
    jsurf.XData = X;
    jsurf.YData = Y;
    
    az = az + 0.15;
    view(az,el)
    pause(0.08)
end
