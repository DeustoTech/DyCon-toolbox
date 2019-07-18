%--------------------------------------------------------------------------
%Created by: Salem Nafiri (FSSM - Faculty of Sciences Semlalia Marrakesh)
%Problem: 1d Thermoelastic Problem,
%Method: Finite element method
%Version date: 06/07/2014
% \partial_tt u = \partial_xx u - \Gamma*\teta_x , 
% \partial_t\teta   = \partial_xx\teta +\Gamma*\partial_tx u
% u|0,L=0 && \teta|0,L=0 (Dirichlet/Dirichlet conditions)
% I.C: u0,v0=\partial u_t0, teta0
%--------------------------------------------------------------------------
%              decay of energy of beam thermoelastic equation
%--------------------------------------------------------------------------
% 
% parameters
%
%  n        : size of matrix
% Gamma: is a positive constant
%
function [u,v,theta,Et] = data_effect_exp(T,dt,n,k,Gamma)
%
%Data of the system
%
col=['b','r','g'];
L=pi;
%
h=L./(n+1);  %Space step
x=h:h:n*h;   %Space variable
t=0:dt:T;    %time variable 
%Initial data
u0=zeros(1,n);
v0=sqrt(2/pi)*sin(k*x); % sin(x) or sin(j*pi*x/L) which is less regular
teta0=zeros(1,n);
u0=u0';
v0=v0';
teta0=teta0';
U0=[u0;v0;teta0];
%
% construction de la matrice D, A et I
%
Dn=diag(1:n,0);
In=eye(n);
for i=1:n
    for j=1:n
        if mod(abs(i-j),2)==0 Fn(i,j)=0;
        else   Fn(i,j)=(-4/pi)*((i*j)/(i*i-j*j));
        end
    end
end
% Generate An (Dirichlet-Dirichlet BC)
%-------------------------------------
An=[zeros(n) Dn zeros(n);
     -Dn      zeros(n) -Gamma*Fn ;
    zeros(n)  Gamma*Fn'  -Dn^2];
%------------------------------------
%
% Allocation de l'espace m�moire de e
e=[];
%u=[];
A=full(An);
E0=1/2*(norm(U0(1:n))^2 + norm(U0(n+1:2*n))^2 + norm(U0(2*n+1:3*n))^2);
%%
Ut = zeros(length(U0),length(t));
Et = zeros(1,length(t));

for i=1:length(t)
    U=expm(t(i)*A)*U0;
    E=1/2*(norm(U(1:n))^2 + norm(U(n+1:2*n))^2 + norm(U(2*n+1:3*n))^2);
    E=E/E0;
    Ut(:,i) = U;
    Et(i)   = E;
end
%%
dim = length(U0)/3;
u     = Ut(1         : dim    , :).';
v     = Ut(dim+1     : 2*dim  , :).';
theta = Ut(2*dim + 1 : end    , :).';
end