function plot(iCP,varargin)
% name: GradientMethod
% description: Since most of the optimization methods require an iterative process, plot shows how the dynamics, 
%               the control and the functional in the optimization evolve.
% little_description: shows how the dynamics, the control and the functional in the optimization evolve.
% autor: JOroya
% MandatoryInputs:   
%   iCP: 
%       name: Control Problem
%       description: 
%       class: ControlProblem
%       dimension: [1x1]
% OptionalInputs:
%   Graphs:
%       description: Parameter that indicate if the method must plot the optimization, while is calculate 
%       class: logical
%       dimension: [1x1]
%       default: false        
%   TypeGraphs:
%       description: Type of graphs. This parameter can be 'ODE' or 'PDE' 
%       class: string
%       dimension: [1x1]
%       default: 'ODE'
%   SaveGif:
%       name: If this parameter is true, A gif of the optimization process is created
%       description: matrix 
%       class: double
%       dimension: [length(iCP.tspan)]
%       default: false

    p = inputParser;
    
    addRequired(p,'iCP',@iCP_valid)
    addOptional(p,'TypeGraphs','ode')
    addOptional(p,'SaveGif',false)
    
    parse(p,iCP,varargin{:})
    
    SaveGif     = p.Results.SaveGif;
    TypeGraphs  = p.Results.TypeGraphs;
    
    nY = length(iCP.ode.InitialCondition);
    nU = length(iCP.solution.UOptimal(1,:));
    
    
    TypeGraphs = class(iCP.ode); 
    [axY,axU,axJ] = init_graphs_gradientmethod(TypeGraphs,nY,nU,SaveGif);
    
    Jhistory = iCP.solution.Jhistory;
    tspan = iCP.ode.tspan;
    for iter = 2:iCP.solution.iter
        Ynew = iCP.solution.Yhistory{iter};
        Unew = iCP.solution.Uhistory{iter};
        bucle_graphs_gradientmethod(axY,axU,axJ,Ynew,Unew,Jhistory,tspan,iter,TypeGraphs,SaveGif,false)
    end
end



function iCP_valid(iCP)
    if isempty(iCP.solution)
        error('The Control proble must be solve before to plot graphs.')
    end
end
