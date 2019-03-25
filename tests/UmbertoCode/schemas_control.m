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

function [soly]=solution_forward(y0,adjoint,donnees,discr,matrices,malla)
dt=donnees.T/discr.Mtemps;          
%C = speye(100,100)+dt*(matrices.M\matrices.A);
        if norm(adjoint) ~= 0
        dt=donnees.T/discr.Mtemps;
        dx = malla.pas;
        tspan = 0:dt:donnees.T;
        xline =  malla.xi;
        s = 3;

        U_norm_Ls = trapz(tspan,trapz(xline,abs(adjoint).^s));
        U_norm_Ls = U_norm_Ls.^(1/s);
        %
        U_norm_Ls = U_norm_Ls^(2-s);
        
        %U_norm_Ls = norm(adjoint,s);
        U = matrices.B*matrices.Bstar*(adjoint.*(abs(adjoint).^(s-2)));
        U = U_norm_Ls*U;
        else
            U = adjoint*0;
        end 
        
        %normL1P = norm(adjoint,1);
%         normL1P = sum(sum(abs(adjoint)))*dx*dt;
%         U = matrices.B*matrices.Bstar*sign(adjoint);
%         U = normL1P*U;
        
        soly=zeros(size(y0,1),discr.Mtemps+1);
        
        soly(:,1)=y0;
        for i=1:discr.Mtemps
            soly(:,i+1)=matrices.C\(soly(:,i) ...
				  + dt*U(:,i));
        end
% 
%             figure
%          surf(matrices.Bstar*adjoint)
%          title('Umberto Control')  
        display("P ="+norm(adjoint))
        
        
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

    
    
    soly= solution_forward(0*phi0,solphi,donnees,discr,matrices,maillage);
    
    w=soly(:,discr.Mtemps+1);

end

function [f,it]=grad_conj(maillage,discr,donnees,matrices,secmem,epsilon,tol,verbose,f_init,y0,soly_libre)
    
    maillages_control;
        calcul_norme_Eh=maill_funcs{2}; 
        produitscalaire_Eh=maill_funcs{3};
    
    it_restart=5000;
    f=f_init*0 + 0.1; 

    Lambdaf=grammian(f,maillage,discr,donnees,matrices);
            
    g = Lambdaf - secmem;
    %g = - secmem;
    %%
    %g=g+epsilon*f;
    s = 3;
    xspan = maillage.xi;
    %f_norm_Ls = trapz(xspan,abs(f).^s);
    %f_norm_Ls = f_norm_Ls.^(1/s);
    f_norm_Ls = norm(f,s);
    f_norm_Ls = f_norm_Ls^(2-s);
    g=g+epsilon*f_norm_Ls*f.*(abs(f).^(s-2));
    
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
        %display(norm(Lambdaw))
%         figure 
%         subplot(1,2,1)
%         plot(Lambdaw)
%         title('YZeroInitial Umberto')
%         subplot(1,2,2)
%         plot(w)
%         title('w Umberto')
%         
       % display(norm(Lambdaw))

	    %newgbar = Lambdaw + epsilon*w;
	    
        
        f_norm_Ls = norm(w,s);
        f_norm_Ls = f_norm_Ls^(2-s);
        
    
        newgbar = Lambdaw + epsilon*(f_norm_Ls*w.*(abs(w).^(s-2)));

        rho = produitscalaire_Eh(maillage,g,g,0)/ ...
        produitscalaire_Eh(maillage,newgbar,w,0);
        f=f-rho*w;
        newg = g - rho*newgbar;

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
                %fprintf('Iteration %g - Error %4.3e - Time: %d seconds\n',it,erreur_gradconj,round(toc()));
            end
        end
%         display("gamma = "+norm(gam))
%         display("rho =" +norm(rho))

    

    %%
                
            solphi_1=solution_adjoint(f,maillage,discr,donnees,matrices);

            
            dt=donnees.T/discr.Mtemps;
            dx = maillage.pas;
            tspan = 0:dt:donnees.T;
            xline =  maillage.xi;

            U_norm_Ls = trapz(tspan,trapz(xline,abs(solphi_1).^s));
            U_norm_Ls = U_norm_Ls.^(1/s);
            %
            U_norm_Ls = U_norm_Ls^(2-s);

            U = matrices.B*matrices.Bstar*(solphi_1.*(abs(solphi_1).^(s-2)));
            controle_1 = U_norm_Ls*U;
        
            soly_1=solution_forward(y0,solphi_1,donnees,discr,matrices,maillage);
            
            cout_controle_temps=zeros(discr.Mtemps,1);

%             figure
            subplot(1,3,1)
            surf(controle_1)
            subplot(1,3,2)
            surf(soly_1)
            subplot(1,3,3)
            plot(soly_1(:,end))
            pause
            for j=1:discr.Mtemps
                cout_controle_temps(j)=calcul_norme_Eh(maillage,controle_1(:,j),0);
            end
            
            %fprintf("Size of the controlled solution at time T: %4.2e\n",...
            %         calcul_norme_Eh(maillage,soly_1(:,discr.Mtemps+1),0));
            %fprintf("Size of the uncontrolled solution at time T: %4.2e\n",...
            %         calcul_norme_Eh(maillage,soly_libre(:,discr.Mtemps+1),0));
            
            F_eps=1/2*sum(cout_controle_temps.^2)*donnees.T/discr.Mtemps...
                +1/(2*epsilon)*calcul_norme_Eh(maillage,soly_1(:,discr.Mtemps+1),0).^2;
            %fprintf('F_eps(v_eps)= %g \n',F_eps)
%             hold on
%             plot(it,F_eps,'*')
            J_eps=1/2*sum(cout_controle_temps.^2)*donnees.T/discr.Mtemps+...
            epsilon/2*calcul_norme_Eh(maillage,f,0)^2+...
            produitscalaire_Eh(maillage,solphi_1(:,1),y0,0);
            fprintf('F_eps(v_eps)= %g \n',F_eps)
%             hold on
%             plot(it,J_eps,'*')
            %fprintf('-J_eps(q_eps)= %g \n',J_eps);
            
            %fprintf('F_(v_opt)~J(mu_opt)= %g \n',abs(F_eps+J_eps)/(abs(F_eps)+abs(J_eps)));   
    %%


end
            
    Lambdaf=grammian(f,maillage,discr,donnees,matrices);
    w = Lambdaf - secmem;
    w = w + epsilon * f;
%     
%     figure
%     plot(f)
%     title('F optimal Umberto')
    
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

