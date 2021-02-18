function Xsol = solve(isys,Control)

%% Setting and Validation of Input Parameters  
    if isys.HasSolver
        Xsol = isys.solver(isys.InitialCondition,Control);
    else
        warning('The object ode doesn''t have solver. By default, we SetIntegrator = Euler  ')
        SetIntegrator(isys,'Euler')
        Xsol = isys.solver(isys.InitialCondition,Control);
    end
    
end

