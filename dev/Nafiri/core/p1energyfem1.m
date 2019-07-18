%--------------------------------------------------------------------------
%Created by: Salem Nafiri (FSSM - Faculty of Sciences Semlalia Marrakesh)
%Problem: 1d Thermoelastic Problem, FEM
%Method: Finite element method
%Version date: 13/07/2014
% \partial_tt u = \partial_xx u - \Gamma*\teta , 
% \partial_t\teta   = \partial_xx\teta +\Gamma*\partial_t u
% u|0,L=0 && \teta|0,L=0 (Dirichlet/Dirichlet conditions)
% I.C: u0,v0=\partial u_t0, teta0
%--------------------------------------------------------------------------
%              decay of energy of thermoelastic equation
%--------------------------------------------------------------------------
% 
% parameters
%
%  n        : size of matrix
% Gamma: is a positive constant
%
function [u,v,theta,Et] = p1energyfem1(T,dt,n,k,Gamma)
%
%Data of the system
%
col=['b','r','g'];
L=pi;
%
h=L./(n+1);  %Space step
x=h:h:n*h;    %Space variable
t=0:dt:T;
%
%Initial data
u0=zeros(1,n);
v0=sqrt(2/pi)*sin(k*x); % sin(x) or sin(j*pi*x/L) which is less regular
teta0=zeros(1,n);
u0=u0';
v0=v0';
teta0=teta0';
U0=[u0;v0;teta0];
% construction de vecteur unit�
e1=ones(n,1);
% construction de la matrice A, M et I
%
% Construct matrix Mn
Mn1=1/h*spdiags([-e1 2*e1 -e1],[-1 0 1],n,n);
M1=full(Mn1);
Mn23=h*spdiags([1/6*e1 2/3*e1 1/6*e1],[-1 0 1],n,n);
M2=full(Mn23);
B=inv(M2)*M1;
In=eye(n);
% Build matrix Gn
Gn=[zeros(n) In  zeros(n);
    -B zeros(n) -Gamma*In;
    zeros(n) Gamma*In -B];
%
% Semigroup solution
%
%F=1/2*(norm(An^(3/2)*U0(1:n))^2 + 1/rho*norm(An^(1/2)*U0(n+1:2*n))^2 + mu/(rho*sigma)*norm(An^(1/2)*U0(2*n+1:3*n))^2);
e=[];
%u=[];
G=full(Gn);
E0=1/2*(norm(sqrtm(B)*U0(1:n))^2 + norm(U0(n+1:2*n))^2 + norm(U0(2*n+1:3*n))^2);

%%
Ut = zeros(length(U0),length(t));
Et = zeros(1,length(t));
for i=1:length(t)
    U=expm(t(i)*G)*U0;
    Ut(:,i) = U;

    E=1/2*(norm(sqrtm(B)*U(1:n))^2 + norm(U(n+1:2*n))^2 + norm(U(2*n+1:3*n))^2);
    E=E/E0;
    %u=[u U];
    e=[e E];
        Et(i) = E;

end

%%
dim = length(U0)/3;
u     = Ut(1         : dim    , :).';
v     = Ut(dim+1     : 2*dim  , :).';
theta = Ut(2*dim + 1 : end    , :).';

end