%% 
% Choose following parameters 
s = 0.5;
N = 100;
L = 1;
%% 
% Execute the function
A = rigidity_fr_laplacian(s,L,N);
%% 
% Can see graphically representation of matrix
figure(1)
mesh(A) 
view(155,100)
