classdef GUI_diff_handle < handle
    %GUI_DIFF_HANDLE Summary of this class goes here
    %   Detailed explanation goes here
    properties
       
       dynamics
       grid
       Sources
       matrix
       click = false
       %
       InitialCondition
       Solution
       FinalCondition
       EstimationInitialCondition
       EstimationSolution
       % graphs 
       surf_evolution
       surf_estimation
       figure
       axes
       SourcePlot
       % 
       N
       btn_gm
       openning_box
       path
    end
end

