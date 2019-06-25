function ValidatorODEControl(obj)
    if ~isa(obj,'sym')
       error('The Control must be symbolic vector') 
    end
end