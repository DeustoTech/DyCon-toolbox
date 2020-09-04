function [A,B] = GetABmatrixnew(Nx)

    %% STEP 1. Definition of A, the "model" of the system

    A=(Nx^2)*(full(gallery('tridiag',Nx-2,1,-2,1)));

    %% STEP 2. Definition of B, the matrix associated to the control operator.

    B = zeros(Nx-2,1);
    B(1) = (Nx-2)^2;
    B(Nx-2) = (Nx-2)^2;

end
