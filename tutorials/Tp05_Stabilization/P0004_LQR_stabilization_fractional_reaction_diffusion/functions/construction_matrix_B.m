function [B] = construction_matrix_B(x,N,M)

B = zeros(N,N);

control = feval(M,x);
block = diag(control);
B(1:N,1:N) = block;

end