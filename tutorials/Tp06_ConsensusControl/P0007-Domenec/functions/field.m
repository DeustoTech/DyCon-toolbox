function y=field(A,G,x)
    y = A*x+arrayfun(G,x);
end
