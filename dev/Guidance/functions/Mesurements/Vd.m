function [result] = Vd(State,Nd)

result =  reshape(State(end-2*Nd:end  ) ,2 , Nd);


end

