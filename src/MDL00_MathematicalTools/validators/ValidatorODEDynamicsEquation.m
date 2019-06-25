function ValidatorODEDynamicsEquation(obj)

    example = ['For Example:',newline,'          DynamicEquation = @(t,Y,U,Params) A*Y + B*U + t'];
    if ~isa(obj,'function_handle') && ~isempty(obj)
       error(['The Dynamic Equation must be function handle.',example]) 
    elseif nargin(obj)~=4
       error([newline,'The Dynamics equation must have 4 arguments.',example])
    end
end