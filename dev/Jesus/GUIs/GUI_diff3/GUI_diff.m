%%
%%
if ismac
    FontDefault = 12;
    FontTitle = 20;
else
    FontDefault = 12;
    FontTitle = 16;

end
%%
h = GUI_diff_handle;
h.path  = replace(which('sheep_dog.m'),'sheep_dog.m','');

h.openning_box = javax.swing.JFrame;
h.openning_box.setSize(382,128);
h.openning_box.setLocationRelativeTo([]);
h.openning_box.setUndecorated(true);
h.openning_box.setOpacity(0.9);

JLabel = javax.swing.JLabel;

logo_path = fullfile(h.path,'imgs','LogoDyconERC-1.png');

[X,map] = imread(logo_path,'Background',[0.7 0.7 0.7]);

JLabel.setIcon(javax.swing.ImageIcon(im2java(X)));
h.openning_box.add(JLabel);
h.openning_box.setVisible(true);

pause(3)
h.openning_box.setVisible(0)

%%

N = 20;
h.N = N;

h.figure = figure('Unit','norm','Position',[0.15 0.05 0.7 0.9],'Toolbar','none','MenuBar','none','NumberTitle','off','Name','Pollution Source Identification'); 

set(h.figure,'DefaultuipanelFontSize',FontDefault)
set(h.figure,'DefaultuicontrolFontSize',FontDefault)

%%
mainpanel = uipanel('Parent',h.figure,'Unit','norm','Position', [0.0  0.85  1 0.2]);
main_str  = 'Goal: Given a random pollution distribution of the swimming pool we find the location of the sources and their intensities. ';
ui_main = uicontrol('Parent',mainpanel,'style','text','string',main_str,'unit','norm','pos',[0.1 0.15 0.8 0.4],'FontSize',FontTitle);
%% 
wd = 1.0;
ht = 0.2;

ht_control = 0.15;
ht_des     = 0.15;
ht_graphs  = 0.75;

iPanelEvol = uipanel('Parent',h.figure,'Title','','Unit','norm','Position', [0  0.0 1/2 0.85]);
    IPEv_text    = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 ht_graphs+ht_control 1.0 ht_des]);
    IPEv_graphs  = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 ht_control 1.0 ht_graphs]);
    IPEv_control = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 0.0 1.0 ht_control]);
iPanelEsti = uipanel('Parent',h.figure,'Title','','Unit','norm','Position', [1/2  0.0 1/2 0.85]);
    IPEs_text    = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 ht_graphs+ht_control 1.0 ht_des]);
    IPEs_graphs  = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 ht_control 1.0 ht_graphs]);
    IPEs_control = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 0.0 1.0 ht_control]);

%% Text 
FontDefault2 = 15;
text = 'Pollution measurements';
uicontrol('style','text','string',text,'Parent',IPEv_text,'unit','norm','pos',[0.2 0.05 0.6 0.4],'Fontsize',FontDefault2)

text = 'Location of the pollution sources and their intensities';
uicontrol('style','text','string',text,'Parent',IPEs_text,'unit','norm','pos',[0.1 0.05 0.8 0.4],'Fontsize',FontDefault2)
%%
generate_dynamics(h)

%% Axes
h.axes.EvolutionGraphs = axes('Parent',IPEv_graphs);
[xms,yms] = meshgrid(h.grid.xline,h.grid.yline);
h.surf_evolution = surf(xms,yms,zeros(N,N),'Parent',h.axes.EvolutionGraphs );
caxis(h.axes.EvolutionGraphs,[0 10])
shading(h.axes.EvolutionGraphs,'interp')
colormap(h.axes.EvolutionGraphs,'jet')

h.surf_evolution.PickableParts = 'none';

view(0,90);
axis(h.axes.EvolutionGraphs ,'off')
h.figure.WindowButtonDownFcn = {@axes_callback_diff_down,h};
h.figure.WindowButtonUpFcn   = {@axes_callback_diff_up,h};
h.figure.WindowButtonMotionFcn   = {@axes_callback_diff_motion,h};

%
h.axes.EstimationGraphs = axes('Parent',IPEs_graphs);
h.surf_estimation = surf(xms,yms,zeros(N,N),'Parent',h.axes.EstimationGraphs );
view(h.axes.EstimationGraphs,0,90);
shading(h.axes.EstimationGraphs,'interp')
axis(h.axes.EstimationGraphs ,'off')
caxis(h.axes.EstimationGraphs,[0 10])
colormap(h.axes.EstimationGraphs,'jet')


h.grid.xms = xms;
h.grid.yms = yms;

%%
%%
%%

if ismac
    pos = [0.15 0.3 0.3 0.4];
    pos_rest = [0.4 0.3 0.3 0.4];
else
    pos = [0.3 0.3 0.4 0.4];
    pos_rest = [0.3 0.3 0.4 0.4];

end

%btn_dyn    = uicontrol('Parent',IPEv_control,'String','Random Distribution','Unit','norm','Position',pos,'Callback',{@btn_random_distribution,h});
btn_rest    = uicontrol('Parent',IPEv_control,'String','Clear','Unit','norm','Position',pos_rest,'Callback',{@btn_reset_distribution,h});

%%
h.btn_gm    = uicontrol('Parent',IPEs_control,'String','Find Sources','Unit','norm','Position',[0.18 0.3 0.3 0.4],'Callback',{@btn_gm_callback,h});

%btn_gm_stop    = uicontrol('Parent',IPEs_control,'String','Stop Gradient Method','Unit','norm','Position',[0.375 0.3 0.3 0.3],'Callback',{@btn_gm_stop_callback,h});
btn_gm_see    = uicontrol('Parent',IPEs_control,'String','See Evolution','Unit','norm','Position',[0.55 0.3 0.3 0.4],'Callback',{@btn_gm_see_callback,h});


