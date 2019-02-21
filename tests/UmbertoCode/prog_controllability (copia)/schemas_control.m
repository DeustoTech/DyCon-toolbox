%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Initialization of the matrices needed in the code
%%%%  A = rigidity matrix
%%%%  B = control operator
%%%%  C = matrix of the implicit Euler method
%%%%  M = mass matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Construction of the matrix M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

schm_func=localfunctions;

function [matrices,maillage]=init_matrices(maillage,discr)

    global donnees
    
    matrices=struct();
    matrices.B=construction_matrice_B(maillage,donnees);
    matrices.Bstar=inv(maillage.H_Uh)*(matrices.B)'*maillage.H_Eh;
    matrices.A=construction_matrice_A(maillage,donnees);
        
    dt=donnees.T/discr.Mtemps;
    
    M=2/3*eye(maillage.N);
    for i=2:maillage.N-1
        M(i,i+1)=1/6;
        M(i,i-1)=1/6;
    end
    M(1,2)=1/6;
    M(maillage.N,maillage.N-1)=1/6;
            
    M=maillage.pas*sparse(M);
    matrices.M=M;
            
    matrices.C=speye(maillage.N,maillage.N)+dt*(matrices.M\matrices.A);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Construction of the matrix A (fractional Laplacian)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A]=construction_matrice_A(maillage,donnees)
         
         A=fl_rigidity(donnees.param_s,1,maillage.N);  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Construction of the matrix B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [B]=construction_matrice_B(maillage,donnees)

        B = sparse(maillage.N*donnees.nbeq,maillage.N*donnees.nbc);

        bloc=sparse(maillage.N,maillage.N);

            for j=1:donnees.nbeq
                for k=1:donnees.nbc
                    controlejk=evaluation_simple(maillage.xi,donnees.mat_B);

                    bloc=diag(controlejk);

                    B( 1+(j-1)*maillage.N:j*maillage.N ,...
                        1+(k-1)*maillage.N:k*maillage.N )=bloc;
                end   
            end

%         B=sparse(maillage.N*donnees.nbeq,maillage.N*donnees.nbc);
% 
%              
%         for i=2:maillage.N-1
%             B(i,i) = maillage.pas;
%             B(i,i+1) = 0.5*maillage.pas;
%             B(i,i-1) = 0.5*maillage.pas;
%         end
%         B(1,1) = maillage.pas;
%         B(1,2) = 0.5*maillage.pas;
%         B(maillage.N,maillage.N-1) = 0.5*maillage.pas;
%         B(maillage.N,maillage.N) = maillage.pas;
%         
%         B = aux*B;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Solution to the direct problem 
%%%%
%%%% u_t + (-d_x^2)^s u = f, (x,t) in (-1,1)x(0,T)                   
%%%% u=0,                    (x,t) in [R\(-1,1)]x(0,T)               
%%%% u(0)=u_0,                x in (-1,1)                            
%%%%
%%%% using implicit Euler method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [soly]=solution_forward(y0,adjoint,donnees,discr,matrices)
        
        soly=zeros(size(y0,1),discr.Mtemps+1);
        dt=donnees.T/discr.Mtemps;  
        soly(:,1)=y0;
        for i=1:discr.Mtemps
            soly(:,i+1)=matrices.C\(soly(:,i) ...
				  + dt*matrices.B*matrices.Bstar*adjoint(:,i));
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Solution to the adjoint problem 
%%%%
%%%% -v_t + (-d_x^2)^s v = 0, (x,t) in (-1,1)x(0,T)                   
%%%% v=0,                     (x,t) in [R\(-1,1)]x(0,T)               
%%%% v(T)=v_T,                 x in (-1,1)                            
%%%%
%%%% using implicit Euler method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [solphi]=solution_adjoint(phi0,maillage,discr,donnees,matrices)

        solphi=zeros(size(phi0,1),discr.Mtemps+1);
        solphi(:,discr.Mtemps+1) = phi0;
        for i=discr.Mtemps:-1:1
            solphi(:,i)=matrices.C\solphi(:,i+1);
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Finite Element approximation of the fractional Laplacian on (-L,L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function A = fl_rigidity(s,L,N)

x = linspace(-L,L,N+2);
x = x(2:end-1);
h = x(2)-x(1);

A = zeros(N,N);

%%%%  Normalization constant of the fractional Laplacian

c = (s*2^(2*s-1)*gamma(0.5*(1+2*s)))/(sqrt(pi)*gamma(1-s));

%%%%  Elements A(i,j) with |j-i|>1

for i=1:N-2
    for j=i+2:N
        k = j-i;
        if s==0.5 && k==2
            A(i,j) = 56*log(2)-36*log(3);   
        elseif s==0.5 && k~=2
            A(i,j) = -(4*((k+1)^2)*log(k+1)+4*((k-1)^2)*log(k-1)...
                -6*(k^2)*log(k)-((k+2)^2)*log(k+2)-((k-2)^2)*log(k-2));
        else
            P = 1/(4*s*(1-2*s)*(1-s)*(3-2*s));
            q = 3-2*s;
            B = P*(4*(k+1)^q+4*(k-1)^q-6*k^q-(k-2)^q-(k+2)^q);
            A(i,j) = -2*h^(1-2*s)*B;
        end       
    end
end

%%%%  Elements of A(i,j) with j=1+1 ----- upper diagonal

for i=1:N-1
    if s==0.5
       A(i,i+1) = 9*log(3)-16*log(2);
    else 
       A(i,i+1) = h^(1-2*s)*((3^(3-2*s)-2^(5-2*s)+7)/(2*s*(1-2*s)*(1-s)*(3-2*s))); 
    end    
end

A = A+A';

%%%%  Elements on the diagonal

for i=1:N
    if s==0.5
       A(i,i) = 8*log(2);
    else 
       A(i,i) = h^(1-2*s)*((2^(3-2*s)-4)/(s*(1-2*s)*(1-s)*(3-2*s)));
    end
end

A = c*A; 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Implementation of the penalized HUM (see F. Boyer - On the penalized
%%%%  HUM approach and its application to the numerical approximation of
%%%%  null-controls for parabolic problems)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [w] = grammian(phi0,maillage,discr,donnees,matrices)

    solphi=solution_adjoint(phi0,maillage,discr,donnees,matrices);
    soly= solution_forward(0*phi0,solphi,donnees,discr,matrices);
    
    w=soly(:,discr.Mtemps+1);

end

function [f,it]=grad_conj(maillage,discr,donnees,matrices,secmem,epsilon,tol,verbose,f_init)
    
    maillages_control;
        calcul_norme_Eh=maill_funcs{2}; 
        produitscalaire_Eh=maill_funcs{3};
    
    it_restart=5000;
    f=f_init; 

    Lambdaf=grammian(f,maillage,discr,donnees,matrices);
            
    g = Lambdaf - secmem;
    
    g=g+epsilon*f;
    
    w=g;

    erreurinit=calcul_norme_Eh(maillage,g,0);
    normeinit=calcul_norme_Eh(maillage,secmem,0);


    erreurtemps=[erreurinit];

    erreur_gradconj=10*tol;
    it=0;

    tic
    while (erreur_gradconj>tol) 

        it=it+1;

        Lambdaw=grammian(w,maillage,discr,donnees,matrices);
	
	    newg = Lambdaw + epsilon*w;

        rho = produitscalaire_Eh(maillage,g,g,0)/ ...
        produitscalaire_Eh(maillage,newg,w,0);
        f=f-rho*w;
        newg = g - rho*newg;

        erreur_gradconj=calcul_norme_Eh(maillage,newg,0)/erreurinit;

        if (erreur_gradconj>tol) 

            gam=produitscalaire_Eh(maillage,newg,newg,0)/ ...
                produitscalaire_Eh(maillage,g,g,0);

            if (mod(it,it_restart)==0)  
                gam=0;
            end
            w=newg+ gam*w;
        end	
        g=newg;
        fprintf("Iteration %g - Error %4.3e \n",it,erreur_gradconj);

        if verbose=='oui' 
            if (mod(it,500)==0) 
                fprintf('Iteration %g - Error %4.3e - Time: %d seconds\n',it,erreur_gradconj,round(toc()));
            end
        end

    end

    Lambdaf=grammian(f,maillage,discr,donnees,matrices);
    w = Lambdaf - secmem;
    w = w + epsilon * f;
    
    fprintf('Gap = %s \n',string(calcul_norme_Eh(maillage,w,0)));

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

