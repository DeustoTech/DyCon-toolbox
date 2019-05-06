if ismac
    FontDefault = 12;
    FontTitle = 20;
else
    FontDefault = 12;
    FontTitle = 16;

end


h = GUI_diff_handle;
h.figure = figure('Unit','norm','Position',[0.15 0.05 0.7 0.9],'Toolbar','none','MenuBar','none','NumberTitle','off','Name','Inverse Problem'); 

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
ht_graphs  = 0.7;

iPanelEvol = uipanel('Parent',h.figure,'Title','','Unit','norm','Position', [0  0.0 1/2 0.85]);
    IPEv_text    = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 ht_graphs+ht_control 1.0 ht_des]);
    IPEv_graphs  = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 ht_control 1.0 ht_graphs]);
    IPEv_control = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 0.0 1.0 ht_control]);
iPanelEsti = uipanel('Parent',h.figure,'Title','','Unit','norm','Position', [1/2  0.0 1/2 0.85]);
    IPEs_text    = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 ht_graphs+ht_control 1.0 ht_des]);
    IPEs_graphs  = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 ht_control 1.0 ht_graphs]);
    IPEs_control = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 0.0 1.0 ht_control]);

%%

text = 'Random generated swimming pool pollution distribution';

    
uicontrol('style','text','string',text,'Parent',IPEv_text,'unit','norm','pos',[0.1 0.05 0.8 0.7],'Fontsize',FontDefault)

text = 'Location of the pollution sources and their intensities';
uicontrol('style','text','string',text,'Parent',IPEs_text,'unit','norm','pos',[0.1 0.05 0.8 0.6],'Fontsize',FontDefault)

%%
% h.axes.InitialGraphs = axes('Parent',IPI_graphs);
% icg.Title.String = 'Initial Condition';
% surf([0 0;0 0],'Parent',h.axes.InitialGraphs )
% view(0,90);axis(h.axes.InitialGraphs ,'off');

h.axes.EvolutionGraphs = axes('Parent',IPEv_graphs);
evg.Title.String = 'Evolution';
surf([0 0;0 0],'Parent',h.axes.EvolutionGraphs )
view(0,90);axis(h.axes.EvolutionGraphs ,'off')

h.axes.EstimationGraphs = axes('Parent',IPEs_graphs);
esg.Title.String = 'Initial Condition Estimation';
surf([0 0;0 0],'Parent',h.axes.EstimationGraphs )
view(0,90);axis(h.axes.EstimationGraphs ,'off')
%%
generate_dynamics(h)
%%
%%

if ismac
    pos = [0.35 0.3 0.3 0.4];
else
    pos = [0.3 0.3 0.4 0.4];
end

btn_dyn    = uicontrol('Parent',IPEv_control,'String','Random Distribution','Unit','norm','Position',pos,'Callback',{@btn_solve_dyn_callback,h});

%%
btn_gm    = uicontrol('Parent',IPEs_control,'String','Find Sources','Unit','norm','Position',[0.18 0.3 0.3 0.4],'Callback',{@btn_gm_callback,h});
%btn_gm_stop    = uicontrol('Parent',IPEs_control,'String','Stop Gradient Method','Unit','norm','Position',[0.375 0.3 0.3 0.3],'Callback',{@btn_gm_stop_callback,h});
btn_gm_see    = uicontrol('Parent',IPEs_control,'String','See Evolution','Unit','norm','Position',[0.55 0.3 0.3 0.4],'Callback',{@btn_gm_see_callback,h});


