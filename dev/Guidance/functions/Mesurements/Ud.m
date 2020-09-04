function [result] = Ud(State,Nd)

result =  reshape(State(end-4*Nd+1:end-2*Nd) ,2 , Nd);

end

