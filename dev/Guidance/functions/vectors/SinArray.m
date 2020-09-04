function [result] = SinArray(u1,u2)
    result =  sum(u1.*flipud(u2).*[1;-1])./(NormArray(u1).*NormArray(u2));  % normas
end

