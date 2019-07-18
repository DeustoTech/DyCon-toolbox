function isurf= rampa(xline_2,yline_2,radius,y0,ax)
%RAMPA Summary of this function goes here
%   Detailed explanation goes here
mat = [xline_2,yline_2];
mat = unique(mat,'rows');
zFcn = @(x) interp1(mat(:,1),mat(:,2),x);

yline = (-2*radius:0.005:2*radius);
yline = yline - y0;

[xms,yms] = meshgrid(mat(:,1),yline);

zms = zFcn(xms) + (yms+y0).^2;

isurf = surf(xms,yms,zms,'LineStyle','none','FaceLighting','gouraud','Parent',ax);
isurf.CData =  isurf.CData*0.002;
end

