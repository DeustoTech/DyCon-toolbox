function AnimationMovilControl(Xnum_with_control,Xnum_free,tspan,xline,yline,Bmatrix)
%ANIMATIONMOVILCONTROL Summary of this function goes here
%   Detailed explanation goes here

Ns = length(xline);
[xms,yms] = meshgrid(xline,yline);

tspan_fine = linspace(tspan(1),tspan(end),4*length(tspan));

Xnum_with_control    = interp1(tspan,Xnum_with_control(:,1:end)',tspan_fine)';
Xnum_free            = interp1(tspan,Xnum_free',tspan_fine)';
%%
xline_fine = linspace(xline(1),xline(end),8*length(xline));
yline_fine = linspace(yline(1),yline(end),8*length(yline));
[xms_fine,yms_fine] = meshgrid(xline_fine,yline_fine);
%%


figure('unit','norm','pos',[0 0 1 1]);

ax1 = subplot(1,3,1);
Z = reshape(Xnum_with_control(1:end-4,1),Ns,Ns);
isurf = surf(xms_fine,yms_fine,interp2(xms,yms,Z,xms_fine,yms_fine,'spline'),'Parent',ax1);
ax2 = subplot(1,3,2);
Z = reshape(Xnum_free(1:end-4,1),Ns,Ns);
jsurf = surf(xms_fine,yms_fine,interp2(xms,yms,Z,xms_fine,yms_fine,'spline'),'Parent',ax2);
ax3 = subplot(1,3,3);
Z = reshape(diag(Bmatrix(Xnum_with_control(1,end)',Xnum_with_control(1,end-1)')),Ns,Ns);
ksurf =surf(xms_fine,yms_fine,interp2(xms,yms,Z,xms_fine,yms_fine),'Parent',ax3);

zlim(ax1,[-1 2])
zlim(ax2,[-1 2])
zlim(ax3,[-0.1 1])
%
view(ax1,-5,10)
view(ax2,-5,10)
view(ax3,-0,90)
%
caxis(ax1,[-0.1 0.1])
caxis(ax2,[-0.1 0.1])
caxis(ax3,[ 0 0.5])
%
shading(ax1,'interp')
shading(ax2,'interp')
%
lighting(ax1,'gouraud')
lighting(ax2,'gouraud')

%
lightangle(ax1,40,40)
lightangle(ax2,40,40)

title(ax1,'Control Dynamics')
title(ax2,'Free Dynamics')
title(ax3,'Sub-domain - \omega')

%%

for it = 1:length(tspan_fine)
    % controled state
    Z = reshape(Xnum_with_control(1:end-4,it),Ns,Ns);
    isurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'spline');
    %
    Z = reshape(Xnum_free(1:end-4,it),Ns,Ns);
    jsurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'spline');
    %
    Z = reshape(diag(Bmatrix(Xnum_with_control(end-3,it)',Xnum_with_control(end-2,it)')),Ns,Ns);
    ksurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'linear');
    pause(0.05)
end

end

