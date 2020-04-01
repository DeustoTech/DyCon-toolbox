function results = ind2state(ind,Ne,Nq)
%IND2ACCTION Summary of this function goes here
%   Detailed explanation goes here
results =  str2num(dec2base(ind,Nq,Ne)');
end

