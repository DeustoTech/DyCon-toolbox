function [result] = Vem(State,Ne)

result =  mean(reshape(State(2*Ne+1:4*Ne),2,Ne),2);

end

