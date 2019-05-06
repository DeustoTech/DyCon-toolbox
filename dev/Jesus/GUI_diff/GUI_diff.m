
clear
h = GUI_diff_handle;
h.figure = figure('Unit','norm','Position',[0.1 0.1 0.8 0.7],'Toolbar','none','MenuBar','none','NumberTitle','off','Name','Inverse Problem'); 

set(h.figure,'DefaultuipanelFontSize',13)
%%
mainpanel = uipanel('Parent',h.figure,'Unit','norm','Position', [0.0  0.85  1 0.2]);
main_str  = 'Goal: To recover the initial sources from a given final distribution of a diffusion-advection system.';
ui_main = uicontrol('Parent',mainpanel,'style','text','string',main_str,'unit','norm','pos',[0.1 0.1 0.8 0.4],'FontSize',20);
%% 
wd = 1.0;
ht = 0.2;

ht_control = 0.2;
ht_des     = 0.20;
ht_graphs  = 0.6;

iPanelInit = uipanel('Parent',h.figure,'Title','Initial Condition','Unit','norm','Position', [0.0  0.0 1/3 0.85]);
    IPI_text    = uipanel('Parent',iPanelInit,'Unit','norm','Pos',[0.0 ht_graphs+ht_control 1.0 ht_des]);
    IPI_graphs  = uipanel('Parent',iPanelInit,'Unit','norm','Pos',[0.0 ht_control 1.0 ht_graphs]);
    IPI_control = uipanel('Parent',iPanelInit,'Unit','norm','Pos',[0.0 0.0 1.0 ht_control]);
iPanelEvol = uipanel('Parent',h.figure,'Title','Evolution of System','Unit','norm','Position', [1/3  0.0 1/3 0.85]);
    IPEv_text    = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 ht_graphs+ht_control 1.0 ht_des]);
    IPEv_graphs  = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 ht_control 1.0 ht_graphs]);
    IPEv_control = uipanel('Parent',iPanelEvol,'Unit','norm','Pos',[0.0 0.0 1.0 ht_control]);
iPanelEsti = uipanel('Parent',h.figure,'Title','Initial Condition Estimation','Unit','norm','Position', [2/3  0.0 1/3 0.85]);
    IPEs_text    = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 ht_graphs+ht_control 1.0 ht_des]);
    IPEs_graphs  = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 ht_control 1.0 ht_graphs]);
    IPEs_control = uipanel('Parent',iPanelEsti,'Unit','norm','Pos',[0.0 0.0 1.0 ht_control]);

%%

%%
h.axes.InitialGraphs = axes('Parent',IPI_graphs);
icg.Title.String = 'Initial Condition';
surf([0 0;0 0],'Parent',h.axes.InitialGraphs )
view(0,90);axis(h.axes.InitialGraphs ,'off');

h.axes.EvolutionGraphs = axes('Parent',IPEv_graphs);
evg.Title.String = 'Evolution';
surf([0 0;0 0],'Parent',h.axes.EvolutionGraphs )
view(0,90);axis(h.axes.EvolutionGraphs ,'off')

h.axes.EstimationGraphs = axes('Parent',IPEs_graphs);
esg.Title.String = 'Initial ConditionEstimation';
surf([0 0;0 0],'Parent',h.axes.EstimationGraphs )
view(0,90);axis(h.axes.EstimationGraphs ,'off')
%%
generate_dynamics(h)
%%
btn_random = uicontrol('Parent',IPI_control,'String','Ramdon Sources','Unit','norm','Position',[0.1 0.3 0.3 0.4],'Callback',{@btn_random_callback,h});
str_random = uicontrol('style','text','Parent',IPI_control,'String','Number of Sources:','Unit','norm','Position',[0.5 0.3 0.2 0.3]);
edit_random = uicontrol('style','edit','Parent',IPI_control,'String','10','Unit','norm','Position',[0.7 0.3 0.1 0.3]);

h.parameters.NSource = edit_random;
%%
btn_dyn    = uicontrol('Parent',IPEv_control,'String','Solve Dynamics ','Unit','norm','Position',[0.1 0.3 0.3 0.4],'Callback',{@btn_solve_dyn_callback,h});
btn_ani    = uicontrol('Parent',IPEv_control,'String','Animation','Unit','norm','Position',[0.5 0.3 0.3 0.4],'Callback',{@btn_solve_ani_callback,h});

%%
btn_gm    = uicontrol('Parent',IPEs_control,'String','Gradient Method','Unit','norm','Position',[0.1 0.2 0.3 0.3],'Callback',{@btn_gm_callback,h});
btn_gm_stop    = uicontrol('Parent',IPEs_control,'String','Stop Gradient Method','Unit','norm','Position',[0.45 0.2 0.3 0.3],'Callback',{@btn_gm_stop_callback,h});
btn_gm_see    = uicontrol('Parent',IPEs_control,'String','See Evolution','Unit','norm','Position',[0.75 0.2 0.3 0.3],'Callback',{@btn_gm_see_callback,h});


