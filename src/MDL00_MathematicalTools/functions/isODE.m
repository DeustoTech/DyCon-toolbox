function isODE(obj)
%ISODE Summary of this function goes here
%   Detailed explanation goes here
    if ~(isa(obj,'ode')||isa(obj,'LinearODE'))
       error('This function is neither ODE nor LinearODE') 
    end
end

