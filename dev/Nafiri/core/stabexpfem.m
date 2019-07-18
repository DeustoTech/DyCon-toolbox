%--------------------------------------------------------------------------
%Created by: Salem Nafiri (FSSM - Faculty of Sciences Semlalia Marrakesh)
%Problem: 1d Thermoelastic Problem, SM
%Method: Finite element method
%Version date:12/04/2013
% \partial_tt u = \partial_tt u - Gamma*\teta_x , 
% \partial_t    = Gamma*\partial_tx u + k*\partial_xx \teta
% u|0,pi=0 && \teta|0,pi=0 (Dirichlet/Neumann conditions)
% I.C: u0,v0=\partial u_t0, teta0
%--------------------------------------------------------------------------
%              Resolution of thermoelastic equation
%--------------------------------------------------------------------------

function[d] = stabexpfem(Nm)
%[e] = stabpolyfem(Nm)
%This function computes the eigenvalues of the matrix An

Gamma=0.1;  %Coupling parameter
for k=1:4
h=pi./(k*(Nm+1));  % Space step

% Build a vector of ones
e1=ones(k*Nm,1);
% Construct matrix Mn
Mn1=spdiags([-1/2*e1 e1 -1/2*e1],[-1 0 1],k*Nm,k*Nm);
Mn23=spdiags([1/4*e1 e1 1/4*e1],[-1 0 1],k*Nm,k*Nm);
Mn=[Mn1      zeros(k*Nm) zeros(k*Nm);
    zeros(k*Nm)  Mn23     zeros(k*Nm);
    zeros(k*Nm) zeros(k*Nm) Mn23];
% Build matrix Bn
Dn=1/h*spdiags([-sqrt(3)/2*e1 sqrt(3)*e1 -sqrt(3)/2*e1],[-1 0 1],k*Nm,k*Nm);
Fn=1/h*spdiags([3/4*e1 0.*e1 -3/4*e1],[-1 0 1],k*Nm,k*Nm);
Gn=1/h/h*spdiags([-3/2*e1 3*e1 -3/2*e1],[-1 0 1],k*Nm,k*Nm);
Bn=[zeros(k*Nm) Dn  zeros(k*Nm);
    -Dn zeros(k*Nm) -Gamma*Fn;
    zeros(k*Nm) Gamma*Fn' -Gn];
% Cholesky decomposition Mn=L'*L
L1=decltl(1,-1/2,k*Nm);
L2=decltl(1,1/4,k*Nm);
L3=L2;
% Generate An (D/D BC)
An=[zeros(k*Nm) inv(L1')*Dn*inv(L2)  zeros(k*Nm);
    -inv(L2')*Dn*inv(L1) zeros(k*Nm) -Gamma*inv(L2')*Fn*inv(L3);
    zeros(k*Nm) Gamma*inv(L3')*Fn'*inv(L2) -inv(L3')*Gn*inv(L3)];
% Get the eigenvalues of An
 e = eig(An);
 disp(['pour n=',num2str(k*Nm) ', d=' num2str(min(-real(e)),'%e')]);
 %close all  % Closes all currently open figures.
%figure (k)
%plot real and imaginary parts
 subplot(2,2,k)
 plot(real(e),imag(e),'b.') 
axis([-0.006 0 -10*k 10*k])
axis square
 %xlabel('Real')
 %ylabel('Imaginary')
 t1=['n=', num2str(k*Nm)];
 title(t1)
end
end
 