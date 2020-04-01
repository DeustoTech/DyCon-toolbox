function Xsol = solve(isys,Control)

%% Setting and Validation of Input Parameters  
Xsol = isys.solver(isys.InitialCondition,Control);

%varargout = {isys.solver(isys,varargin{:})};
end

