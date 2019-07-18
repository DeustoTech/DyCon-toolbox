function ValidatorPontryaginDiffLagrangeState(idynamics,dLdy)
%VALIDATORPONTRYAGINDIFFFINALCOSTSTATE Summary of this function goes here
%   Detailed explanation goes here

if isempty(dLdy)
    return
end

Ytest001 = zeros(idynamics.StateDimension,1);
time0001 = 0;
           
example = ['For example:',newline,'   dLdY = @(t,Y,U) Y'];
subject = 'The State Derivative of Final Cost Term';

if ~isa(dLdy,'function_handle')
    error([subject,' must be function_handle',example])
elseif nargin ~= 2
    error([subject,'must have two input parameters.',example])
end
    
try
    result = dLdy(time0001,Ytest001);

catch err
    err.getReport
    error([subject,' have a some problem'])
end

len = length(result);
[nrow,ncol] = size(result);
errortext = [subject,' the output must have the dimension: [1x',num2str(idynamics.StateDimension),'], but it have: [',num2str(nrow),'x',num2str(ncol),']'];
if len ~= idynamics.StateDimension
    %error(errortext)
elseif nrow ~= 1
    %error(errortext)
end
    
end

