%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Solution to the adjoint problem 
%%%%
%%%% -v_t + (-d_x^2)^s v = 0, (x,t) in (-1,1)x(0,T)                   
%%%% v=0,                     (x,t) in [R\(-1,1)]x(0,T)               
%%%% v(T)=v_T,                 x in (-1,1)                            
%%%%
%%%% using implicit Euler method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [solphi]=solution_adjoint(phi0,maillage,donnees,matrices)

        solphi=zeros(size(phi0,1),donnees.Nt+1);
        solphi(:,donnees.Nt+1) = phi0;
        for i=donnees.Nt:-1:1
            solphi(:,i)=matrices.C\solphi(:,i+1);
        end
end