

%%
clear all
mu = 0.001;
ibound =    0.6000;
kappa = 1;
Nx = 50;
m=randominitial(Nx,ibound,kappa);
%y=ObtainEllipticSolution(m,mu,Nx);
y = m*0;
tic
[yNew , mNew]= IPOPT_FD(y,m,Nx,ibound,kappa,mu);
toc
%%
close all
plotell(yNew,mNew,Nx,mu)

