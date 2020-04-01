function y = Window(x,a,b)
%
    y = 1-ThetaHeaviside(-x+a) - ThetaHeaviside(x-b);
end

