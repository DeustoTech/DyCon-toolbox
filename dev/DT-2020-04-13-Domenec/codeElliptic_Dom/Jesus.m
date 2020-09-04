

%%
clear all
tic
mu = 0.001;
ibound =    0.6000;
kappa = 1;
Nx = 100;
m=randominitial(Nx,2,ibound,kappa);
%y=ObtainEllipticSolution(m,mu,Nx);
y = m*0;
[yNew , mNew]= IPOPT_FD(y,m,Nx,ibound,kappa,mu,2);
toc
%%
% close all
% plotell(yNew,mNew,Nx,mu)
% 
