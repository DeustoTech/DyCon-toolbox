% You can execute this function with follow basic parameters
%
  s = 0.5;
  L = 1;
  N = 100;
  A = rigidity_fr_laplacian(s,L,N);

% You can see graphically:
%
   mesh(A)
