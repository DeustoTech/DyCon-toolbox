function ValidatorPontryaginL(obj)
%VALIDATORPONTRYAGINPSI Summary of this function goes here
%   Detailed explanation goes here
    example = ['For Example:',newline, ...
     '          Psi = @(t,Y,U) Y.^2 + U.^2'];

    if ~isa(obj,'function_handle') && ~isempty(obj)
       error(['The Dynamic Equation must be function handle.',example]) 
    elseif nargin(obj)~=3
       error([newline,'The Dynamics equation must have 3 arguments.',example])
    end
    
end

