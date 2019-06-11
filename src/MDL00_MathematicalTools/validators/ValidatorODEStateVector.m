function ValidatorODEStateVector(obj)
    if ~isa(obj,'sym')
       error('The State Vector must be symbolic vector') 
    end
end