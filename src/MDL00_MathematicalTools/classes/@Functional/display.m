function display(iFunctional)
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here

Lchar   = ['L(Y,U,t)     =  ',char(iFunctional.symL)];
Psichar = ['Psi(Y,t)     =  ',char(iFunctional.symPsi)];
tab = '     ';
display([newline,tab,'The functional J = Psi(Y,t) + \int (L(Y,U,t)) dt',newline,newline, ...
        tab,tab,Lchar,newline, ...
        tab,tab,Psichar,newline,newline, ...
        tab,'In interval of time:',newline,newline, ...
        tab,tab,'t in [0,',num2str(iFunctional.T),']',newline])

    
end

