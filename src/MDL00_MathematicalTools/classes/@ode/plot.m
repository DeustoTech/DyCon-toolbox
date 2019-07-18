function plot(iode,varargin)
% description: The ode class, if only de organization of ode.
%               The solve of this class is the RK family.
% autor: JOroya
% OptionalInputs:
%   DynamicEquation: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
%   StateVector: 
%       description: StateVector
%       class: Symbolic
%       dimension: [1x1]
%   Control: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
%   A: 
%       description: simbolic expresion
%       class: matrix
%       dimension: [1x1]
%   B: 
%       description: simbolic expresion
%       class: matrix
%       dimension: [1x1]            
%   InitialControl:
%       name: Initial Control 
%       description: matrix 
%       class: double
%       dimension: [length(iCP.tspan)]
%       default:   empty   

    p = inputParser;
    addRequired(p,'iode');
    addOptional(p,'Parent',[])
    
    
    parse(p,iode,varargin{:})
    
    Parent = p.Results.Parent;
    
    if isempty(Parent)
        f = figure;
        Parent = axes('Parent',f);        
    end
        
    
        plot(iode.tspan,iode.StateVector.Numeric,'Parent',Parent)

        legend(string(iode.StateVector.Symbolic))
        Parent.YLabel.String = 'states';
        Parent.XLabel.String = 'time(s)';
        Parent.Title.String = 'solution';
end

