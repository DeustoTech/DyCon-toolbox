function validatorPontryaginDynamics(obj)
%VALIDATORPONTRYAGINDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
if ~(isa(obj,'ode')||isa(obj,'pde'))
    error('The dynamics must be a pde/ode object')
end
end

