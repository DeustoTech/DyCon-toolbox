function L=decltl(x,y,N)
%
% Algorithme de decomposition A=LtL 
% ou A est la matrice tridiagonale symetrique 
% de diagonale a, sur et sous-diagonale b.
% 
% parametres
%
%  N        : taille de la matrice
%  x        : N-vecteur, diagonale de A
%  y        : (N-1)-vecteur, sur et sous-diagonale de A
%
% remplissage de la matrice A
%
for i=1:N
  l(i)=x;
end
for i=1:(N-1)
  m(i)=y;
end
%
% algorithme de decomposition A=LtL
%
l(N)=sqrt(x);
for i=1:N-1
m(N-i)=y/l(N-i+1); 
l(N-i)=sqrt(x-m(N-i)*m(N-i));  
end
%
%Generation de la matrice L
%
L=diag(m,-1)+diag(l,0);
L=full(L);
%
%
%

