function [result] = Ue(State,Ne)

    result = reshape(State(1:2*Ne) ,2 , Ne);

end

