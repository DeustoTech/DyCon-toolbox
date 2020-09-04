function plotRF(f,Vpot,xl,vl,al,pi,W,Nxl,Nvl,dt)
fig = figure(1);
clf
subplot(2,1,1)
plot(xl,Vpot(xl))
xlim([xl(1) xl(end)])
  

[xms,vms] = meshgrid(xl,vl);
  
ax_V = subplot(1,3,1);
isurf = surf(xms,vms,W,'Parent',ax_V);
view(0,90)
title('Función Valor')
shading interp
colorbar

ax_pi = subplot(1,3,2);
jsurf = surf(xms,vms,al(pi),'Parent',ax_pi);
view(0,90)
title('Feedback Control')
shading interp
colorbar


ax_b = subplot(1,3,3);
T = 1;
xl_less = linspace(xl(1),xl(end),floor(Nxl/4));
vl_less = linspace(vl(1),vl(end),floor(Nvl/4));


phasep(@(s) f(s,evaluatePolicy(s,xl,vl,al,pi)),T,dt,xl_less,vl_less)
view(0,90)
xlabel('x')
xlabel('v')

title('phase portait')
shading interp
colorbar