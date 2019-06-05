classdef HUM 
    %HUM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Dynamics
        Adjoint 
        Epsilon  double = 1
        Target
        
    end
    
    properties (Hidden)
        zerodynamics
    end
    methods
        function obj = HUM(dynamics)
            %HUM Construct an instance of this class
            %   Detailed explanation goes here
            p = inputParser;
            addRequired(p,'dynamics',@valid_dyn)
            
            obj.Dynamics     = copy(dynamics);
            obj.zerodynamics = copy(dynamics);
            obj.zerodynamics.InitialCondition = 0*obj.zerodynamics.InitialCondition;
            obj.Target = dynamics.InitialCondition*0;
            %%
            obj.Adjoint           = pde('A',obj.Dynamics.A);
            obj.Adjoint.Nt        = obj.Dynamics.Nt ;
            obj.Adjoint.FinalTime = obj.Dynamics.FinalTime ;

            obj.Adjoint.mesh = obj.Dynamics.mesh ;
            obj.Adjoint.MassMatrix = obj.Dynamics.MassMatrix  ;
           
            function valid_dyn(dyn)
               if  ~dyn.lineal
                  error('HUM class only works with lineal Dynamics') 
               end
            end
        end

    end
end

