%%
clear all
load('WP05Rumba3.mat')
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

zlim(ax1,[-1 1])
zlim(ax2,[-1 1])
zlim(ax3,[-0.5 1.5])
%
view(ax1,-5,10)
view(ax2,-5,10)
view(ax3,-0,90)
%
caxis(ax1,[-1 1])
caxis(ax2,[-1 1])
caxis(ax3,[ 0 0.5])
%
shading(ax1,'interp')
shading(ax2,'interp')
%
lightangle(ax1,40,40)
lightangle(ax2,40,40)
%
lighting(ax1,'gouraud')
lighting(ax2,'gouraud')
%
title(ax1,'Control Dynamics')
title(ax2,'Free Dynamics')
title(ax3,'Sub-domain - \Omega')


%%

for it = 1:length(tspan_fine)
    % controled state
    Z = reshape(Xnum_with_control(1:end-4,it),Ns,Ns);
    isurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'linear');
    %
    Z = reshape(Xnum_free(1:end-4,it),Ns,Ns);
    jsurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'cubic');
    %
    Z = reshape(diag(Bmatrix(Xnum_with_control(end-3,it)',Xnum_with_control(end-2,it)')),Ns,Ns);
    ksurf.ZData = interp2(xms,yms,Z,xms_fine,yms_fine,'cubic');
    pause(0.05)
end
