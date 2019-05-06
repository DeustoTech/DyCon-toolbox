classdef GUI_diff_handle < handle
    %GUI_DIFF_HANDLE Summary of this class goes here
    %   Detailed explanation goes here
    properties
       figure
       StateVectorSolution
       InitialStateVector
       dynamics
       axes
       grid
       Sources
       InitialCondition
       kmax
       matrix
       parameters
       stop_gm = false
       EstimationInitialCondition
       EstimationSolution
    end
end

