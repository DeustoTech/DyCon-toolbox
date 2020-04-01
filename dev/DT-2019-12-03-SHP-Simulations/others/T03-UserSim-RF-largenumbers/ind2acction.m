function results = ind2acction(ind,Ne)
%IND2ACCTION Summary of this function goes here
%   Detailed explanation goes here
results = str2num(dec2bin(ind,Ne)');
end

