%% load data 
% [Pxvect Pyvect]
% [Pxvect_uncontrol Pyvect_uncontrol]

load('uncontrolled.mat')

Pxvect_uncontrol = Pxvect;
Pyvect_uncontrol = Pyvect;

load('controlled.mat')

%% Create Figure and axes 
fig = figure('Units','normalized','Position',[0 0 1 1],'Color','k');
% 
axControl  = subplot(1,2,1,'Parent',fig,'Color',fig.Color);
axFree     = subplot(1,2,2,'Parent',fig,'Color',fig.Color); 

axBar      = axes('Parent',fig,'unit','norm','pos',[0.05 0.05 0.9 0.025]);
% fixed the limits axis 
xlim(axBar,[0 1]);
ylim(axBar,[0 1]);
axis(axBar,'off')
%% Create red bar time 
rectangle('Parent',axBar,'FaceColor','w')
irect = rectangle('Parent',axBar,'FaceColor','r');
irect.Position = [0 0 0 1];

%% Create 2 rotors
x1 = -10; % min x point of rotor
x2 =  10; % max x point of rotor

[controlsurf,R,T,H]   = RotorGeometry(x1,x2,axControl);
[uncontrolsurf,R,T,H] = RotorGeometry(x1,x2,axFree);


axControl.Color = fig.Color;
axFree.Color = fig.Color;


FinalTime = 5;
time = linspace(0,5,length(Pxvect));
%% Rescale data  
Factor = 0.01;

Rescale = @(x) Factor*x;
p1y = Rescale(Pxvect);  
p1z = Rescale(Pyvect); 
%
p2y = Rescale(Pxvect); 
p2z = Rescale(Pyvect); 
%
p1y_uncontrol = Rescale(Pxvect_uncontrol);  
p1z_uncontrol = Rescale(Pyvect_uncontrol);  
%
p2y_uncontrol = Rescale(Pxvect_uncontrol);  
p2z_uncontrol = Rescale(Pyvect_uncontrol);  
%%
vx = [1 0 0];

%% Create Text
annotation('textbox','String','Control','FontSize',26,'Color','w',      'Pos',[0.275 0.8 0.3 0.1])
annotation('textbox','String','Free','FontSize',26,'Color','w','Pos',[0.7 0.8 0.3 0.1])

%%
l1minus10 = line(-8,p2y_uncontrol(1),p2z_uncontrol(1),'Parent',axFree,'Marker','o','LineStyle','-','Color',[0.8 0.8 0.8],'MarkerSize',3);

az =-25;
el = 15;
view(axFree,az,el)
view(axControl,az,el)
%% Animation in Time
% angle == velocity of rotor rotation 
dalpha = 20;

for it = 1:30:length(time) 
    %%
    irect.Position(3) = it/length(time);
    
    if it == 1
        [angle,orto_vec,trans_z,trans_y,vec] =  updateaxisrotor(controlsurf,it,p2y,p1y,p2z,p1z);
    else
        [angle,orto_vec,trans_z,trans_y,vec] =  updateaxisrotor(controlsurf,it,p2y,p1y,p2z,p1z,trans_z,trans_y,orto_vec,angle);
    %
    end
    %%
    %%
    if it == 1
        [angle_uncontrol,orto_vec_uncontrol,trans_z_uncontrol,trans_y_uncontrol,vec_uc] =  updateaxisrotor(uncontrolsurf,it,p2y_uncontrol,p1y_uncontrol,p2z_uncontrol,p1z_uncontrol);
    else
        [angle_uncontrol,orto_vec_uncontrol,trans_z_uncontrol,trans_y_uncontrol,vec_uc] =  updateaxisrotor(uncontrolsurf,it,p2y_uncontrol,p1y_uncontrol,p2z_uncontrol,p1z_uncontrol,trans_z_uncontrol,trans_y_uncontrol,orto_vec_uncontrol,angle_uncontrol);
    %
    end    
    %%
    origin = [0 trans_y trans_z];
    origin_unc = [0 trans_y_uncontrol trans_z_uncontrol];
    for it_small = 1:3
        rotate(controlsurf,vec,dalpha,origin)
        rotate(uncontrolsurf,vec_uc,dalpha,origin_unc)
       
         pause(0.0001)

    end
    %

    if mod(it,3) == 0
    az = az + 0.01;
    view(axFree,az,el)
    view(axControl,az,el)
    end
         pause(0.0001)

end
%%
%%
%% END
%%
%%
function [angle,orto_vec,trans_z,trans_y,vec] = updateaxisrotor(isurf,it,p2y,p1y,p2z,p1z,old_trans_z,old_trans_y,old_orto_vec,old_angle)
vx = [1 0 0];
    if it ~= 1
        % Deshacer las transformaciones
        isurf.ZData = isurf.ZData - old_trans_z;
        isurf.YData = isurf.YData - old_trans_y;
        %
        if sum(old_orto_vec) ~= 0
            rotate(isurf,old_orto_vec,-180*old_angle/pi)
        end

    end
    vec = [20,p2y(it) - p1y(it) , p2z(it) - p1z(it)];
    
    orto_vec = cross(vx,vec);
    angle    = acos(dot(vx,vec)/norm(vec));
    
    if sum(orto_vec) ~= 0
        rotate(isurf,orto_vec,180*angle/pi)        
    end
    
    trans_z = 0.5*(p1z(it)+p2z(it));
    trans_y = 0.5*(p1y(it)+p2y(it));
    %
    isurf.ZData = isurf.ZData + trans_z;
    isurf.YData = isurf.YData + trans_y;
end

