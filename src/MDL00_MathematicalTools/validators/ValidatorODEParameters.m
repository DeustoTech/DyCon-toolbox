function ValidatorODEParameters(obj)
    if ~isa(obj,'param')
       error('The State Vector must be param object') 
    end
end