function ValidatorODEDynamicsEquation(obj)

    example = ['For Example:',newline,'          DynamicEquation = @(t,Y,U) A*Y + B*U + t'];
    if ~isa(obj,'function_handle') && ~isempty(obj)
       error(['The Dynamic Equation must be function handle.',example]) 
    elseif nargin(obj)~=3 
       error([newline,'The Dynamics equation must have 2 arguments.',example])
    end
end