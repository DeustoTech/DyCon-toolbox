function [result] = CosArray(u1,u2)
    result =  sum(u1.*u2)./(NormArray(u1).*NormArray(u2));  % normas
end

