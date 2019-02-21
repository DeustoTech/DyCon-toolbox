%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Discretization of the domain                                           
%%%%       \Omega = (-1,1) in the elliptic case                          
%%%%       Q = (-1,1)x(0,T) in the parabolic case                           
%%%%       Space discretization: finite element                          
%%%%       Time discretization: implicit Euler                           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Uniform mesh 1D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maill_funcs=localfunctions;

function [maillage] = maillage_uniforme(N)
    
    x=linspace(-1,1,N+2)';

    himd = x(2:end-1)-x(1:end-2);
    hipd = x(3:end)-x(2:end-1);
    hi = 0.5*(hipd+himd);
    x = x(2:end-1);

    maillage=struct('nom','maillage uniforme',...
    'dim',1,...
    'xi',x,...
    'hi',hi,...
    'pas',max(hi),...
    'N',N);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Norm in the discrete state space Eh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [n]=calcul_norme_Eh(m,vecteur,s)

    n = sqrt(produitscalaire_Eh(m,vecteur,vecteur,s));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Scalar product in the discrete state space Eh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [n]=produitscalaire_Eh(maill,vecteur,vecteur2,s)

    switch s
        case 0  
            n=vecteur'*maill.H_Eh*vecteur2; 
    end

    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Storage of the mesh size parameters (needed for non-uniform meshes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [maill]=calcul_matrices_masse(m)

    global donnees;
    maill=m;
        
        bloc=sparse(maill.N,maill.N);
        M = 2/3*eye(maill.N,maill.N);
                M(1,2)=1/6;
                M(2,1)=1/6;
                
                for i=2:maill.N-1
                    M(i+1,i)=1/6;
                    M(i,i+1)=1/6;
                end
                
                maill.H_Eh=sparse(maill.pas*M);

        
        maill.H_Uh=sparse(maill.N*donnees.nbc,maill.N*donnees.nbc);

        for i=1:maill.N
            bloc(i,i)=maill.hi(i);
        end

        for j=1:donnees.nbc
            maill.H_Uh( 1+(j-1)*maill.N:j*maill.N , 1+(j-1)*maill.N:j*maill.N )=bloc;
        end
 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Evaluation of a given function on a mesh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [v]=evaluation_simple(points,f)
    v=zeros(size(points,1),1);
    
    if isnumeric(f)
        v=f*(1+v);
    elseif isa(f,'function_handle')
        v=feval(f,points);
    else
        disp('Erreur dans le type d''argument passe a evaluation_simple')
    end
end
