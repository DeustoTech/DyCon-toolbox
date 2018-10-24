%profile on
ind=size(nu,2);

c_3=datestr(now);


tic;

for i=1:1:ind

    nu_k=i;
    
    matrices=init_matrices(nu(:,nu_k),maillage);
    
    
    if (~isfield(donnees,'nonlinearite')) 
    
    [mu_r,it]=grad_conj(maillage,donnees,matrices,sec_membre,...
                         donnees.tolerance,'oui',0*sec_membre);
    
    solp_real=solution_adjoint(mu_r,donnees,matrices);
    u_r=matrices.B*solp_real;
    soly_real=solution_forward(u_r,donnees,matrices);
        
    else
        
        it_nonlin=0;
        
        %%% initial guess
        sol_old=0*ones(size(sec_membre,1),1);
        muopt_old=0*sec_membre;
        
        erreur_non_lin=1;
        while ((erreur_non_lin>10^(-8)) && (it_nonlin<donnees.pt_fixe_it_max))     
            it_nonlin=it_nonlin+1;
            y1=sol_old;
            
            %%% Computation of the linearized terms
            [matrices.reaction,matrices.reaction_der]=...
                construction_matrices_reaction(maillage,discr,donnees,y1);
            
            %%% Resolution of the linear control problem
            [muopt,it]=grad_conj(maillage,donnees,matrices,sec_membre,...
            donnees.tolerance,'non',muopt_old);
        
            %%% Computation of the corresponding control
            solp=solution_adjoint(-muopt,donnees,matrices);
            %controle=matrices.B*solp;
            
            %%% Computation of the associated solution
            soly=solution_forward(-solp,donnees,matrices);
            erreur_non_lin=max(abs(soly-sol_old))/max(abs(soly));
            
            %%% On affiche l'état du solveur non-linéaire
            %fprintf('it_nonlin : %g,  it : %g, erreur : %g\n',it_nonlin,it,erreur_non_lin);
            %fprintf('Norme de la solution : %g\n',max(abs(soly)));
            
            %%% On met à jour grâce au paramètre de relaxation choisi
            sol_old=(donnees.relaxation*soly+(1-donnees.relaxation)*sol_old);
            muopt_old=muopt;
	      
        end 
        fprintf(separation);
        fprintf('Erreur dans le système d´optimalité \n')
        fprintf('State z: %4.4e \n',calcul_norme_Eh(maillage,matrices.A*soly+...
            feval(donnees.nonlinearite,soly).*soly+matrices.B*solp,0));
        fprintf('Adjoint p:  %4.4e \n',calcul_norme_Eh(maillage,matrices.A*solp+...
            feval(donnees.nonlinearite_der,soly).*solp+muopt,0))
        
        mu_r=muopt_old;
        
        solp_real=solution_adjoint(mu_r,donnees,matrices);
        u_r=matrices.B*solp_real;
        soly_real=solution_forward(u_r,donnees,matrices);
        
    end
    
    
    
%     [mu_r,it]=grad_conj(maillage,donnees,matrices,sec_membre,...
%                          donnees.tolerance,'oui',0*sec_membre);
%     
%     solp_real=solution_adjoint(mu_r,donnees,matrices);
%     u_r=matrices.B*solp_real;
%     soly_real=solution_forward(u_r,donnees,matrices);
    
    fprintf(separation);
    
    fprintf('Coût du controle : %4.2e\n',...
            calcul_norme_Eh(maillage,u_r,0));
    
    F=1/2*calcul_norme_Eh(maillage,u_r,0)^2+...
      donnees.beta/2*calcul_norme_Eh(maillage,soly_real-yd,0)^2;
    fprintf('F(v_opt)= %g \n',F);
    
    J=1/2*calcul_norme_Eh(maillage,u_r,0)^2+...
      1/(2*donnees.beta)*calcul_norme_Eh(maillage,mu_r,0)^2-...
      produitscalaire_Eh(maillage,mu_r,yd,0);
    fprintf('J(mu_opt)= %g \n',J);
    
    fprintf('F_(v_opt)~J(mu_opt)= %g \n',abs(F+J)/(abs(F)+abs(J)));
    
    switch donnees.surrogate
    
        case 'vectorial'
            if donnees.dim=='1d'
                u_gr=matrices.B*controle{nu_k}(1:maillage.N);
            else
                u_gr=matrices.B*controle{nu_k}(1:maillage.N^2);
            end
            y_gr=solution_forward(u_gr,donnees,matrices);        
        otherwise
            u_gr=matrices.B*controle{nu_k};
            y_gr=solution_forward(controle{nu_k},donnees,matrices);
    end
%     
%     switch donnees.dim
%         case '1d'
%             figure(1)
%             plot(maillage.xi,u_gr,'+',maillage.xi,u_r,'--')
%             figure(2)
%             plot(maillage.xi,y_gr,maillage.xi,yd,maillage.xi,soly_real)
%         case '2d'
%             figure(1)
%             surf(maillage.xi,maillage.yj,reshape(u_gr,maillage.N,maillage.N),'EdgeColor', 'none')
%             figure(2)
%             surf(maillage.xi,maillage.yj,reshape(y_gr,maillage.N,maillage.N),'EdgeColor', 'none')  
%     end
    fprintf('Norm |u_r-u_g|: %e\n',calcul_norme_Eh(maillage,u_r-u_gr,0))
    abs_norm(i)=calcul_norme_Eh(maillage,u_r-u_gr,0);
    fprintf('Norm |y_r-y_g|: %e\n',calcul_norme_Eh(maillage,soly_real-y_gr,0))
    abs_norm_state(i)=calcul_norme_Eh(maillage,soly_real-y_gr,0);
end


toc;

fprintf('Kolmogorov width Sigma %e\n',max(abs_norm))



%profile viewer

c_4=datestr(now);