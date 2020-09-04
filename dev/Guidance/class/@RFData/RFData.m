classdef RFData <   handle
    
    properties
        Qtable
        %
        vars
        actions
    end
    
    methods
        function obj = RFData(n)
            %% state
            str = { {'r' ,linspace(0,10,5)}, ...
                    {'sigma'  ,linspace(5,10,5)}, ...
                    {'ud',linspace(0,10,5)}};
            obj.vars = var.empty;
            iter = 0;
            for istr = str
                iter = iter + 1 ;
               obj.vars(iter) = var(istr{:}{1},istr{:}{2}); 
            end
                 
            %% actions
            str = { {'distance' ,linspace(0,1,2)}};   
            obj.actions = var.empty;
            iter = 0;
            for istr = str
                iter = iter + 1 ;
               obj.actions(iter) = var(istr{:}{1},istr{:}{2}); 
            end
            
            %% Q table
            for i=1:n
            obj.Qtable{i} = zeros(obj.vars.N,obj.actions.N);
            end
        end
        
        function result = state2indexs(obj,state)
            result = arrayfun( @(i) value2index(obj.vars(i),state(i)),1:length(obj.vars),'UniformOutput',false);
        end
    end
end

