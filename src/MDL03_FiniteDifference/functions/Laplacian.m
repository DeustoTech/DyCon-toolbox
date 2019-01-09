function matrix= laplacian1d(N)
%LAPLACIAN1D Summary of this function goes here
%   Detailed explanation goes here

    matrix = diag(repmat(-2,1,N));

    for i = 1:(N-1)
        matrix(i,i+1) = 1;
        matrix(i+1,i) = 1;
    end
    matrix = (N^2)*matrix;
end

