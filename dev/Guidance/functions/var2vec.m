function [v1,v2] = var2vec(M)
    a = M(1,1);
    b = M(2,1);
    c = M(2,2);
    %
    v1 = [b*c/a ; -b^2/a];
    v2 = [-b*c/a ; 1+ b^2/a];

end

