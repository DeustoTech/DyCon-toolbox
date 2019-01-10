function B = Bmatrix()
%BMATRIX Summary of this function goes here
%   Detailed explanation goes here
    syms m1 m2 Lf1 Lf2 
    syms Lg Lo1 L
    
    
    B_11 =  m1/Lf1;
    B_33 =  - 1/(L*Lg*Lo1) ;
    B_42 = m2/Lf2;
    B = [ B_11      0           0      ; ...
           0        0           0      ; ...
           0        0         B_33     ; ...
           0       B_42         0      ; ...
           0        0           0      ; ...
           0        0           0      ; ...
           0        0           0      ];

end

