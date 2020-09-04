function CopySystemProperties(obj,Dynamics)
    if isempty(obj.DynamicSystem)
       error('Fist, you need set the Dynamics System property.') 
    end
    obj.DynamicSystem.MassMatrix = Dynamics.MassMatrix;
    obj.DynamicSystem.tspan  = Dynamics.tspan;
    %
    if isa(Dynamics,'linearode') || ~isa(obj.DynamicSystem,'linearode')
        
    else   
        obj.DynamicSystem.solver = Dynamics.solver;
    end
    %
    if isa(Dynamics,'pde1d') || isa(Dynamics,'linearpde1d')
       obj.DynamicSystem.xline =  Dynamics.xline;
    end
end