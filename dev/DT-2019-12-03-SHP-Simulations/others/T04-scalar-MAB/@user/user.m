classdef user < handle
    %USER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        qdistribution double 
    end
    
    methods
        function obj = user(qdistribution)
            %USER 
            obj.qdistribution = qdistribution;
        end
        
        
        
    end
end

