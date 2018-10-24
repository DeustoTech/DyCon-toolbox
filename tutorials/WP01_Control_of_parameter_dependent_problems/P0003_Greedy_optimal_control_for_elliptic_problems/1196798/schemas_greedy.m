%%***********************************************************************
%%********   Initialisation des matrices A, B, Astar, Bstar qui interviennent dans le code
%%***********************************************************************
%%******** Rappel : donnees contient le cas test choisi par l'utilisateur i.e. donnees=cas_test(n°i)


schm_func=localfunctions;

function [matrices,maillage]=init_matrices(nu,maillage)

    global donnees

    matrices=struct();
    matrices.B=construction_matrice_B(maillage,donnees);
    matrices.Bstar=construction_mat_Bstar(maillage,donnees,matrices);
    matrices.A=construction_matrice_A(nu,maillage,donnees);
    matrices.Astar=construction_mat_Astar(maillage,donnees,matrices.A);

end


%%***********************************************************************
%%********   Construction de la matrice A (-Laplacien)
%%***********************************************************************

function [A]=construction_matrice_A(nu,maillage,donnees)

    if isfield(donnees,'M_manifold')
        nu_pot=nu(2);
        nu=nu(1); 
    else
        nu_pot=1;
    end

    if (maillage.dim==1) 
        A=sparse(maillage.N*donnees.nbeq,maillage.N*donnees.nbeq);
        bloc=sparse(maillage.N,maillage.N);
        for j=1:donnees.nbeq
            coeff=donnees.coeff_diffusion;

            coeffipd=feval(coeff,nu,maillage.xipd); 
                     %%** Un vecteur de taille size(maillage.xipd,1) représentant la fonction de diffusion a (a(x)\Delta)
            coeffimd=feval(coeff,nu,maillage.ximd);
                     %%** Conditions de Dirichlet au bord **
            i=maillage.N;
            bloc(i,i-1)=-coeffimd(i)/(maillage.himd(i)*maillage.hi(i));
            bloc(i,i)=coeffipd(i)/(maillage.hipd(i)*maillage.hi(i)) + coeffimd(i)/(maillage.himd(i)*maillage.hi(i));

            i=1;
            bloc(i,i+1)=-coeffipd(i)/(maillage.hipd(i)*maillage.hi(i));
            bloc(i,i)=coeffipd(i)/(maillage.hipd(i)*maillage.hi(i)) + coeffimd(i)/(maillage.himd(i)*maillage.hi(i));
            %%** **

            for i=2:maillage.N-1
                bloc(i,i+1)=-coeffipd(i)/(maillage.hipd(i)*maillage.hi(i));
                bloc(i,i-1)=-coeffimd(i)/(maillage.himd(i)*maillage.hi(i));
                bloc(i,i)=coeffipd(i)/(maillage.hipd(i)*maillage.hi(i)) + coeffimd(i)/(maillage.himd(i)*maillage.hi(i));
            end

            A( 1+(j-1)*maillage.N:j*maillage.N ,  1+(j-1)*maillage.N:j*maillage.N)=bloc;
            
            if isfield(donnees,'potential')
                %fprintf('adding potential... \n')
                pot=evaluation_simple(maillage.xi,donnees.potential);
                pot_term = spdiags(pot,0,maillage.N,maillage.N);
                A=A+nu_pot*pot_term;
            end
            
        end 
        
    elseif maillage.dim==2
        
        %global matrices
        
        I_c = speye(maillage.N);
        e_c = ones(maillage.N,1);
        T_c = spdiags([-e_c 4*e_c -e_c],[1 0 -1],maillage.N,maillage.N);
        S_c = spdiags([-e_c -e_c],[1 -1],maillage.N,maillage.N);
        A_c = nu*(kron(I_c,T_c) + kron(S_c,I_c))./(maillage.pas^2);
        
        index = spdiags([e_c e_c e_c],[1 0 -1],maillage.N,maillage.N);
        

        coeff=donnees.coeff_diffusion;
        ediag=1/maillage.pas^2*(coeff(nu,maillage.xipd,maillage.yj)...
            +coeff(nu,maillage.ximd,maillage.yj)...
            +coeff(nu,maillage.xi,maillage.yjmd)...
            +coeff(nu,maillage.xi,maillage.yjpd));
        ediag=reshape(ediag,maillage.N*maillage.N,1);
        
        eleft=-1/maillage.pas^2*coeff(nu,maillage.ximd,maillage.yj);
        eleft=reshape(eleft,maillage.N*maillage.N,1);
        
        eright=-1/maillage.pas^2*coeff(nu,maillage.xipd,maillage.yj);
        eright=reshape(eright,maillage.N*maillage.N,1);
        
        T=spdiags([eleft ediag eright],[1 0 -1],maillage.N^2,maillage.N^2);
        T=kron(I_c,index).*T;
        
        eout_right=1/maillage.pas^2*coeff(nu,maillage.xi,maillage.yjpd);
        eout_right=reshape(eout_right,maillage.N*maillage.N,1);
       
        eout_left=1/maillage.pas^2*coeff(nu,maillage.xi,maillage.yjmd);
        eout_left=reshape(eout_left,maillage.N*maillage.N,1);
        
        S = spdiags([-eout_left -eout_right],[maillage.N -maillage.N],maillage.N^2,maillage.N^2);
        
        A=T+S;
        
        if isfield(donnees,'potential')
                %fprintf('adding potential... \n')
                if isfield(donnees,'var_pot')
                    pot=donnees.potential(nu,maillage.xi,maillage.yj);
                    pot=reshape(pot,maillage.N*maillage.N,1);
                    pot_term = spdiags(pot,0,maillage.N^2,maillage.N^2);
                    A=A+nu_pot*pot_term;
                else
                    pot=donnees.potential(maillage.xi,maillage.yj);
                    pot=reshape(pot,maillage.N*maillage.N,1);
                    pot_term = spdiags(pot,0,maillage.N^2,maillage.N^2);
                    A=A+nu_pot*pot_term;
                end
                
               
        end
                       
    end 
end

%%//***********************************************************************
%%//********   Construction de la matrice Astar (sous-optimalement calculée ...)
%%//***********************************************************************



function [Astar]=construction_mat_Astar(maillage,donnees,A)
    
    Astar=sparse(maillage.N*donnees.nbeq,maillage.N*donnees.nbeq);

    if (maillage.dim==1)
        Astar=inv(maillage.H_Eh)*A'*maillage.H_Eh;
    elseif maillage.dim==2
        Astar=A;
    end
end

%%***********************************************************************
%%********   Construction de la matrice B
%%***********************************************************************

function [B]=construction_matrice_B(maillage,donnees)

        if maillage.dim==1

        B=sparse(maillage.N*donnees.nbeq,maillage.N*donnees.nbc);

        bloc=sparse(maillage.N,maillage.N);

            for j=1:donnees.nbeq
                for k=1:donnees.nbc
                    controlejk=evaluation_simple(maillage.xi,donnees.mat_B);

                    bloc=diag(controlejk);

                    B( 1+(j-1)*maillage.N:j*maillage.N , 1+(k-1)*maillage.N:k*maillage.N )=bloc;
                end   
            end
        elseif maillage.dim==2
            contr = donnees.mat_B(maillage.xi,maillage.yj);
            re_contr=reshape(contr,maillage.N*maillage.N,1);
            B=spdiags(sparse(re_contr),0,maillage.N^2,maillage.N^2);
        end
 
end

function [Bstar]=construction_mat_Bstar(maillage,donnees,matrices)

    Bstar=sparse(maillage.N*donnees.nbeq,maillage.N*donnees.nbeq);  
    Bstar=inv(maillage.H_Uh)*(matrices.B)'*maillage.H_Uh;
 
end


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


%%***********************************************************************
%%********   Scalar system: solution to the direct problem
%%********          -d_x(g(x) d_x y)=F   in (0,1)
%%********                         y=0   on {0,1}
%%***********************************************************************

function [soly]=solution_forward(adjoint,donnees,matrices)

    switch donnees.methode

    case 'diff_finite' 
        [soly]=solution_forward_diff_finite(adjoint,matrices);
        
    case 'nonlineaire'   
        [soly]=solution_forward_linearized(adjoint,matrices);
        
    otherwise 
        disp(' choix de discretisation '+discr.methode+' non disponible');
    end

end


%%***********************************************************************
%%********   Scalar system: solution to the direct problem
%%***********************************************************************

function [soly]=solution_forward_diff_finite(adjoint,matrices)
    
    soly=matrices.A\(matrices.B*matrices.Bstar*adjoint);
    
end

%%***********************************************************************
%%********   Scalar system: adjoint problem 
%%***********************************************************************

function [solphi]=solution_adjoint(y,donnees,matrices)

    switch donnees.methode

    case 'diff_finite'
       
        [solphi]=solution_adjoint_diff_finite(y,matrices);
        
    case 'nonlineaire'
            
        [solphi]=solution_adjoint_linearized(y,matrices);

    otherwise 
        disp(' choix de discretisation '+discr.methode+' non disponible');
    end

end

%%***********************************************************************
%%********   Scalar system: solution to the adjoint problem
%%***********************************************************************

function [solphi]=solution_adjoint_diff_finite(y,matrices)
    
    solphi=matrices.Astar\y;

end

function [w] = grammian(mu,donnees,matrices)

    solphi=solution_adjoint(mu,donnees,matrices);
    soly= solution_forward(solphi,donnees,matrices);
    
    w=soly;

end

function [f,it]=grad_conj(maillage,donnees,matrices,secmem,tol,verbose,f_init)
    
    maillages;
        calcul_norme_Eh=maill_funcs{2}; 
        produitscalaire_Eh=maill_funcs{4};
    
    it_restart=5000;
    f=f_init; %** f approche le minimum de la fonctionnelle à chaque itération (x_k)

    Lambdaf=grammian(f,donnees,matrices);
        %** g = Lambdaf - secmem; // Gradient de la fonctionnelle en f   
    
    g = Lambdaf - secmem;
    
    g=g+1/donnees.beta*f;
    
    w=g;

    erreurinit=calcul_norme_Eh(maillage,g,0);
    normeinit=calcul_norme_Eh(maillage,secmem,0);


    erreurtemps=[erreurinit];

    erreur_gradconj=10*tol;
    it=0;

    tic
    while (erreur_gradconj>tol) 

        it=it+1;

        Lambdaw=grammian(w,donnees,matrices);
	
	    newg = Lambdaw + 1/donnees.beta*w;

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
        fprintf("Iteration %g - Erreur %4.3e \n",it,erreur_gradconj);

        if verbose=='oui' 
            if (mod(it,500)==0) 
                printf("Iteration %g - Erreur %4.3e - Temps de calcul : %d secondes\n",it,erreur_gradconj,round(toc()));
            end
        end

    end

    %** Vérification qu'on a bien résolu ce qu'on voulait

    Lambdaf=grammian(f,donnees,matrices);
    w = Lambdaf + 1/donnees.beta*f - secmem;
    
    disp('Ecart = '+string(calcul_norme_Eh(maillage,w,0)));
    

end

function ind=indicator_2D(X,Y,a,b,c,d)
    
    ind = (X>=a).*(X<=b).*(Y>=c).*(Y<=d);

end

function [mat]=matrix_C(matrices,maillage,discr)

global donnees

mat=matrices;

dt=donnees.T/discr.Mtemps;

switch donnees.dim
    case '1d'
        mat.C=speye(maillage.N)+dt*matrices.A;
        mat.Cstar=speye(maillage.N)+dt*matrices.Astar;
    case '2d'
        mat.C=speye(maillage.N^2)+dt*matrices.A;
        mat.Cstar=speye(maillage.N^2)+dt*matrices.Astar;
end
end

%%*************************************************************************
%%******     Scalar system: solution to the evolution problem       *******
%%******            y_t-d_x(g(x) d_x y)=F   in (0,1)                *******
%%******                              y=0   on {0,1}                *******
%%*************************************************************************

function [soly]=solution_forward_evolution(y0,adjoint,donnees,discr,matrices)
   
        [soly]=solution_forward_diff_finite_evolution(y0,adjoint,donnees,discr,matrices);  

end


%%***********************************************************************
%%********   Scalar system: solution to the direct problem
%%***********************************************************************

function [soly]=solution_forward_diff_finite_evolution(y0,adjoint,donnees,discr,matrices)

    soly=zeros(size(y0,1),discr.Mtemps+1);
    
    dt=donnees.T/discr.Mtemps;  

    soly(:,1)=y0;
        for i=1:discr.Mtemps
            soly(:,i+1)=matrices.C\(soly(:,i) ...
				  + dt*matrices.B*matrices.Bstar*adjoint(:,i));
        end
end

%%***********************************************************************
%%********   Scalar system: adjoint problem 
%%***********************************************************************

function [solphi]=solution_adjoint_evolution(phi0,mu,maillage,discr,donnees,matrices)

        [solphi]=solution_adjoint_diff_finite_evolution(phi0,mu,maillage,...
            discr,donnees,matrices);

end

%%***********************************************************************
%%********   Scalar system: solution to the adjoint problem
%%***********************************************************************

function [solphi]=solution_adjoint_diff_finite_evolution(phi0,mu,maillage,...
                    discr,donnees,matrices)
    
    solphi=zeros(size(phi0,1),discr.Mtemps+1);
    dt=donnees.T/discr.Mtemps;
    
        solphi(:,discr.Mtemps+1) = phi0;
        for i=discr.Mtemps:-1:1
            solphi(:,i)=matrices.Cstar\(solphi(:,i+1)+dt*mu(:,i+1));
        end
end

function [w]=HUM_turnpike(phi0,mu,maillage,discr,donnees,matrices)
   
    [solphi]=solution_adjoint_evolution(phi0,mu,maillage,discr,donnees,matrices);
    [soly]=solution_forward_evolution(0*phi0,solphi,donnees,discr,matrices);
    
    %for future implementation
    %w=[soly(:,1:discr.Mtemps+1) donnees.tu_pl_cont*soly(:,discr.Mtemps+1)];
    
    w=soly(:,1:discr.Mtemps+1);
    
end

function [f,mu,it]=grad_conj_turn(maillage,discr,donnees,matrices,secmem,epsilon,tol,verbose,f_init,mu_init)

    maillages;
        calcul_norme_Vh=maill_funcs{10};
        produitscalaire_Vh=maill_funcs{9};

    it_restart=5000;
    f=f_init;
    mu=mu_init;
    %tf=[mu_init f_init]; %%% for future implementation
    tf=mu_init;
    %
    Lambdaf=HUM_turnpike(0*f,mu,maillage,discr,donnees,matrices);
    %%% g = epsilon*f + Lambdaf - secmem; // Gradient de la fonctionnelle en f
    
    g = Lambdaf - secmem;
    %     %% g = g + epsilon*tf;
    %     %% g = g + [1/donnees.beta_param*tf(:,1:discr.Mtemps+1) epsilon*tf(:,discr.Mtemps+2)]
    g = g + [1/donnees.beta*tf(:,1:discr.Mtemps+1)];
    %
    w=g;
    %
    erreurinit=calcul_norme_Vh(maillage,g,0);
    normeinit=calcul_norme_Vh(maillage,secmem,0);
 
    erreurtemps=[erreurinit];
 
    erreur_gradconj=10*tol;
    it=0;

    tic
    while (erreur_gradconj>tol)

        it=it+1;

        %Lambdaw=HUM_turnpike(w(:,discr.Mtemps+2),w(:,1:discr.Mtemps+1),maillage,discr,donnees,matrices)
            %%for future implementation
        Lambdaw=HUM_turnpike(0*f,w(:,1:discr.Mtemps+1),maillage,discr,donnees,matrices);
	
	    newg = Lambdaw;         
        %newg = newg+[1/donnees.beta_param*w(:,1:discr.Mtemps+1) epsilon*w(:,discr.Mtemps+2)]
            %%for future implementation
            
        newg = newg+1/donnees.beta*w(:,1:discr.Mtemps+1);    

        rho = produitscalaire_Vh(maillage,g,g,0)/ ...
            produitscalaire_Vh(maillage,newg,w,0);
        mu=tf(:,1:discr.Mtemps+1);
%         f=tf(:,discr.Mtemps+2);
        tf=tf-rho*w;
        newg = g - rho*newg;
        
        
        %%% for testing purposes with Jose
        solphi=solution_adjoint_evolution(0*f,mu,maillage,discr,donnees,matrices);
        controle_evolution=matrices.B*solphi;
    
        soly=solution_forward_evolution(0*f,controle_evolution,donnees,discr,matrices);
        
        fprintf("rho %g: %4.3e -- max %g: %4.3e -- ",it,rho,it,max(max(soly)));
        
        %%%
        
        erreur_gradconj=calcul_norme_Vh(maillage,newg,0)/erreurinit;

        if (erreur_gradconj>tol) 

            gam=produitscalaire_Vh(maillage,newg,newg,0)/ ...
                produitscalaire_Vh(maillage,g,g,0);

            if (mod(it,it_restart)==0)  
                gam=0;
            end
            w=newg + gam*w;
        end	
        
        g=newg;
        fprintf("Iteration %g - Erreur %4.3e \n",it,erreur_gradconj);

        if verbose=='oui' 
            if (mod(it,500)==0) 
                fprintf("Iteration %g - Erreur %4.3e - Temps de calcul : %d secondes\n",it,erreur_gradconj,round(toc()));
            end
        end
    end
    
    mu=tf(:,1:discr.Mtemps+1);
    f=0*tf(:,discr.Mtemps+1);

%     //Vérification qu'on a bien résolu ce qu'on voulait

    Lambdaf=HUM_turnpike(0*f,mu,maillage,discr,donnees,matrices);
    w = Lambdaf - secmem;
    w = w + 1/donnees.beta*mu;
    disp('Ecart = '+string(calcul_norme_Vh(maillage,w,0)));

end

function [w] = grammian_controllabillity(phi0,mu,maillage,discr,donnees,matrices)

    solphi=solution_adjoint_evolution(phi0,mu,maillage,discr,donnees,matrices);
    soly=solution_forward_evolution(0*phi0,solphi,donnees,discr,matrices);
    
    w=soly(:,discr.Mtemps+1);

end

function [f,it]=grad_conj_controllability(maillage,discr,donnees,matrices,secmem,epsilon,tol,verbose,f_init,rhs)
    
    maillages;
        calcul_norme_Eh=maill_funcs{2}; 
        produitscalaire_Eh=maill_funcs{4};
    
    it_restart=5000;
    f=f_init; %** f approche le minimum de la fonctionnelle à chaque itération (x_k)

    Lambdaf=grammian_controllabillity(f,rhs,maillage,discr,donnees,matrices);
        %** g = Lambdaf - secmem; // Gradient de la fonctionnelle en f   
    
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

        Lambdaw=grammian_controllabillity(w,rhs,maillage,discr,donnees,matrices);
	
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
        fprintf("Iteration %g - Erreur %4.3e \n",it,erreur_gradconj);

        if verbose=='oui' 
            if (mod(it,500)==0) 
                fprintf('Iteration %g - Erreur %4.3e - Temps de calcul : %d secondes\n',it,erreur_gradconj,round(toc()));
            end
        end

    end

    %** Vérification qu'on a bien résolu ce qu'on voulait

    Lambdaf=grammian_controllabillity(f,rhs,maillage,discr,donnees,matrices);
    w = Lambdaf - secmem;
    w = w + epsilon * f;
    
    fprintf('Ecart = %s \n',string(calcul_norme_Eh(maillage,w,0)));

end

%%***********************************************************************
%%********   Scalar system: solution to the linearized problems
%%********   needed for nonlinear case
%%********   computarion of the linearized terms
%%***********************************************************************

function [soly]=solution_forward_linearized(adjoint,matrices)
    
    soly=(matrices.A+matrices.reaction)\(matrices.B*matrices.Bstar*adjoint);
    
end

function [solphi]=solution_adjoint_linearized(y,matrices)
    
    solphi=(matrices.Astar+matrices.reaction_der)\y;

end

function [R,R_der]=construction_matrices_reaction(maillage,discr,donnees,termes_reaction)
    
    nonlin=donnees.nonlinearite(termes_reaction);    
    R = spdiags(nonlin,0,maillage.N^2,maillage.N^2);
    
    nonlin_der=donnees.nonlinearite_der(termes_reaction);
    R_der = spdiags(nonlin_der,0,maillage.N^2,maillage.N^2);
    
end

function [soly]=solution_forward_nonlineaire(adjoint,matrices)
    
    soly=(matrices.A+matrices.reaction)\(matrices.B*matrices.Bstar*adjoint);
    
end



