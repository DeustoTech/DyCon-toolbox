function Xsol = devsolve(isys,Control)

%% Setting and Validation of Input Parameters  
Xsol = isys.solver(isys.InitialCondition,Control);

    
end

