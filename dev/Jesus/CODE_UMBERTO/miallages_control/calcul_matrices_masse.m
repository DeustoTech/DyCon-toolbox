%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%  Storage of the mesh size parameters (needed for non-uniform meshes)
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [maill]=calcul_matrices_masse(donnees,N)


    x=linspace(-1,1,N+2)';

    himd = x(2:end-1)-x(1:end-2);
    hipd = x(3:end)-x(2:end-1);
    hi = 0.5*(hipd+himd);
    x = x(2:end-1);

    maill=struct(    'xi',x,...
    'hi',hi,...
    'dx',max(hi),...
    'N',N);


                
        bloc=sparse(maill.N,maill.N);
        maill.H_Eh=sparse(maill.N,maill.N);
        maill.H_Uh=sparse(maill.N,maill.N);

        for i=1:maill.N
            bloc(i,i)=maill.hi(i);
        end

            maill.H_Eh( 1:maill.N , 1:maill.N )=bloc;

            maill.H_Uh( 1:maill.N , 1:maill.N )=bloc;
 
end
