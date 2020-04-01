function matrix= FDLaplacian(mesh)
%LAPLACIAN1D Summary of this function goes here
%   Detailed explanation goes here


    dx = mesh(2) - mesh(1);
    N = length(mesh);
    matrix = diag(repmat(-2,1,N));

    for i = 1:(N-1)
        matrix(i,i+1) = 1;
        matrix(i+1,i) = 1;
    end
    matrix = (1/dx^2)*matrix;
    matrix = sparse(matrix);
end

