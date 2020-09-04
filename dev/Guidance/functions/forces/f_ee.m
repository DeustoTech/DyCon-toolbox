function [result] = f_ee(x)

kpp= 5e-3; 
dist_ref = 15;
eps = 1e-2;
result =  kpp*((-(x+eps)+dist_ref)./(x+eps));



end

