function phasep(f,T,dt,xl,vl)

Nxl = length(xl);
Nvl = length(vl);

[xms,vms] = meshgrid(xl,vl);

dxms = xms*0;
dvms = vms*0;

for i = 1:Nxl
   for j = 1:Nvl
      s = [xl(i),vl(j)]';
      ds = f(s);
      dxms(j,i) = ds(1);
      dvms(j,i) = ds(2);
   end
end


hold on

tspan = 0:dt:T;

color = 0.2 + 0.8*jet(Nvl*Nxl);
iter = 0;
for iv = vl
    for ix = xl
    iter = iter + 1;
    s0 = [ix;iv];
    [tspan,st] = rk4(@(t,s) f(s),tspan,s0);
    line(st(:,1),st(:,2),'color',color(iter,:),'LineWidth',0.01)

    end
end


quiver(xms,vms,dxms,dvms,1.5,'LineWidth',1.5,'Color',[0.4 0.4 0.4],'LineWidth',1.2)
xlim([xl(1),xl(end)])
ylim([vl(1),vl(end)])

end

