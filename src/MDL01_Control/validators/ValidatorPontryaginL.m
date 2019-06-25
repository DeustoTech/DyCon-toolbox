function ValidatorPontryaginL(obj,Dynamics)
%VALIDATORPONTRYAGINPSI Summary of this function goes here
%   Detailed explanation goes here
    example = ['For Example:',newline, ...
     '          L = @(t,Y,U) Y.^2 + U.^2'];

    if ~isa(obj,'function_handle') && ~isempty(obj)
       error(['The Dynamic Equation must be function handle.',example]) 
    elseif nargin(obj)~=3
       error([newline,'The Dynamics equation must have 3 arguments.',example])
    elseif length(obj(0,Dynamics.InitialCondition, Dynamics.Control.Numeric(1,:).' ) ) ~= 1
        error(['The L must be scalar',example])
    end
    
end

