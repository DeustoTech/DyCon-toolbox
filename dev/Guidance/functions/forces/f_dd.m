function [result] = f_dd(x)

kpp= 20.0; 
result =  kpp*(-1./(x+1e-3).^2);


end

