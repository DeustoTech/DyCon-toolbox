function A = Amatrix
%AMATRIX Summary of this function goes here
%   Detailed explanation goes here
syms Ro1 Rf1 Lf1 Cf1 Lo1
syms Ro2 Rf2 Lf2 Cf2 Lo2
syms  Rg Lg L
%%
%L = (Lg^(-1) + Lo1^(-1) + Lo2^(-1));

A_11 = - Rf1/Lf1;
A_12 = - 1/Lf1;
%
A_21 =   1/Cf1;
A_23 =  -1/Cf1;
%
A_32 =   (1/Lo1)*(1 - 1/(L*Lo1));
A_33 =  -(1/Lo1)*(1 - 1/(L*Lo1))*Ro1;
A_35 =   -1/(L*Lo1*Lo2);
A_36 =  Ro2/(L*Lo1*Lo2);
A_37 =  Ro2/(L*Lo1*Lg);
%
A_44 = -Rf2/Lf2;
A_45 = - 1/Lf2;
%
A_54 = 1/Cf2;
A_56 = - 1/Cf2;
%
A_62 = - 1/(L*Lo1*Lo2);
A_63 =  Ro1/(L*Lo1*Lo2);
A_65 = (1/Lo2)*(1-1/(L*Lo2));
A_66 = -(Ro2/Lo2)*(1-1/(L*Lo2));
A_67 = -Rg/(L*Lg);
% 
A_72 =   1/(L*Lg*Lo1);
A_73 =  -Ro1/(L*Lg*Lo1);
A_75 =  Ro1/(L*Lg*Lo2);
A_76 =  -Ro2/(L*Lg*Lo2);
A_77 = -(Rg/Lg)*(1-1/(L*Lg));


A = [ A_11   A_12    0      0      0      0      0;  ...
      A_21    0     A_23    0      0      0      0;  ...
      0      A_32   A_33    0     A_35   A_36   A_37;...
      0       0      0     A_44   A_45    0      0;  ...
      0       0      0     A_54    0     A_56    0;  ...
      0      A_62   A_63    0     A_65   A_66   A_67;...
      0      A_72   A_73    0     A_75   A_76   A_77];

  
end

