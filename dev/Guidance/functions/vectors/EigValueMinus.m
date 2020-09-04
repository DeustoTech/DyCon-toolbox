function [result] = EigValueMinus(sigma)

result =  (sigma(1,1) + sigma(2,2) - sqrt( (sigma(1,1) - sigma(2,2))^2 + 4*sigma(2,1)^2) ) / 2;

end

