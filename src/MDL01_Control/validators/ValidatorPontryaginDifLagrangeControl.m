function ValidatorPontryaginDifLagrangeControl(idynamics,dLdy)
%VALIDATORPONTRYAGINDIFFFINALCOSTSTATE Summary of this function goes here
%   Detailed explanation goes here

if isempty(dLdy)
    return
end

Utest001 = ones(idynamics.ControlDimension,1);
Ytest001 = ones(idynamics.StateDimension,1);
time0001 = 1;
           
example = ['For example:',newline,'   dLdY = @(t,Y,U) Y'];
subject = 'The State Derivative of Final Cost Term';

if ~isa(dLdy,'function_handle')
    error([subject,' must be function_handle',example])
elseif nargin ~= 2
    error([subject,'must have two input parameters.',example])
end
    
try
    result = dLdy(time0001,Ytest001,Utest001);

catch err
    err.getReport
    error([subject,' have a some problem'])
end

[nrow,ncol] = size(result);
errortext = [subject,' the output must have the dimension: [',num2str(idynamics.ControlDimension),'x1], but it have: [',num2str(nrow),'x',num2str(ncol),']'];
if ncol ~=1||nrow~=idynamics.ControlDimension
    error(errortext)
end
    
end

