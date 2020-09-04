function [A,B] = GetABmatrix(N)

A=(1/3)*(full(gallery('tridiag',N,1,-2,1)));
%%
B = zeros(N,2);
B(1,1) = 1;
B(end,end) = 1;
%%
end

