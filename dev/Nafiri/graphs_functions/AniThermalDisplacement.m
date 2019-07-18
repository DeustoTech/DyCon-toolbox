function AniThermalDisplacement(Temperature,Displacement,Energy,dDisplacement)
%ANITHERMALDISPLACEMENT Summary of this function goes here
%   Detailed explanation goes here
fig = figure('unit','norm','pos',[0 0 1 1]); 

barpanel    = uipanel('Parent',fig,'units','norm','pos',[0 0.7 1 0.3]);
graphspanel = uipanel('Parent',fig,'units','norm','pos',[0 0 1 0.7]);


aniax  =  axes('Parent',barpanel);


Enax =  subplot(2,2,1,'Parent',graphspanel);
tempax =  subplot(2,2,2,'Parent',graphspanel);
dispax =  subplot(2,2,3,'Parent',graphspanel);
dispaxdiff = subplot(2,2,4,'Parent',graphspanel);

[nrow,ncol] = size(Displacement);

[isurf,R,T,H] = CreateCilin(1,ncol,aniax);

Factor = 10;

it = 1;
maxTemp = max(max(Temperature));
maxDisp = max(max(Displacement));
maxDispdiff = max(max(dDisplacement));

%
minTemp = min(min(Temperature));
minDisp = min(min(Displacement));
minDispdiff = min(min(dDisplacement));

%
%%


ldisp = line(1:ncol,Displacement(it,:),'Parent',dispax,'Marker','o');
ylim(dispax,[minDisp maxDisp])
xlim(dispax,[1,ncol])
title(dispax,'Displacement')
%
ldispdiff = line(1:ncol,dDisplacement(it,:),'Parent',dispaxdiff,'Marker','o');
ylim(dispaxdiff,[minDispdiff maxDispdiff])
xlim(dispaxdiff,[1,ncol])
title(dispaxdiff,'Velocity')
%
ltemp = line(1:ncol,Temperature(it,:) ,'Parent',tempax,'Marker','o');
ylim(tempax,[minTemp maxTemp])
xlim(tempax,[1,ncol])
title(tempax,'Temperature')
%
caxis(aniax,[minTemp maxTemp])
%zlim(aniax,[Factor*minDisp Factor*maxDisp])
%
line(1:nrow,Energy ,'Parent',Enax,'Marker','none');
lEn = line(1:it,Energy(1:it) ,'Parent',Enax,'Marker','o');
title(Enax,'Energy')
xlim(Enax,[1 nrow])
ylim(Enax,[Energy(end) Energy(1)])
%%

%%

el = -10;
az = 17;
view(aniax,el,az)
axis(aniax,'off')
title(aniax,'Evolution of a thermo elastic bar')

aniax.Color = fig.Color;


for it = 1:1:nrow

    isurf.ZData = R*cos(T) + Factor*interp1(1:ncol,Displacement(it,:),H);
    isurf.CData = interp1(1:ncol,Temperature(it,:),H);
    %
    ldisp.YData = Displacement(it,:);
    ldispdiff.YData = dDisplacement(it,:);

    ltemp.YData = Temperature(it,:);
    %
    if mod(it,10) == 0
    line(1:ncol,Temperature(it,:) ,'Parent',tempax,'Marker','none','Color',[0.925 0.925 0.925]);
    tempax.Children =  [tempax.Children(2:end);tempax.Children(1)];
    %
    line(1:ncol,Displacement(it,:) ,'Parent',dispax,'Marker','none','Color',[0.925 0.925 0.925]);
    dispax.Children =  [dispax.Children(2:end);dispax.Children(1)];
    %
    line(1:ncol,dDisplacement(it,:) ,'Parent',dispaxdiff,'Marker','none','Color',[0.925 0.925 0.925]);
    dispaxdiff.Children =  [dispaxdiff.Children(2:end);dispaxdiff.Children(1)];
    end
    %
    lEn.XData = 1:it;
    lEn.YData = Energy(1:it);
    %
    el = el + 0.05;
%     view(aniax,el,az)
    pause(0.05)
    
    
end
end

