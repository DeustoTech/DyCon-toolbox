function [result] = Ve(State,Ne)
result = reshape(State(2*Ne+1:4*Ne  ) ,2 , Ne);
end

