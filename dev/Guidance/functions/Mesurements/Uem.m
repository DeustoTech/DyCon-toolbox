function [result] = Uem(State,Ne)

result =  mean(reshape(State(1:2*Ne),2,Ne),2);
%result =  median(reshape(State(1:2*Ne),2,Ne),2);


end

