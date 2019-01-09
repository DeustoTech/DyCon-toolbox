function plot(iode,varargin)
%PLOT Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser;
    addRequired(p,'iode');
    addOptional(p,'Parent',[])
    
    
    parse(p,iode,varargin{:})
    
    Parent = p.Results.Parent;
    
    if isempty(Parent)
        f = figure;
        Parent = axes('Parent',f);        
    end
        
    plot(iode.tline,iode.Y,'Parent',Parent)
    Parent.YLabel.String = 'states';
    Parent.XLabel.String = 'time(s)';
    Parent.Title.String = 'solution';
end

