function [result] = EigVecPlus(sigma)

result =  [ sigma(1,1)^2 + sigma(2,1) - EigValueMinus(sigma);
                        sigma(2,2)^2 + sigma(2,1) - EigValueMinus(sigma)];

end

