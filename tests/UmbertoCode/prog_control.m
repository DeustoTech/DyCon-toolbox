%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controllability of the fractional heat equation                %%%%%%%
%%%%                                                                %%%%%%% 
%%%% u_t + (-d_x^2)^s u = f, (x,t) in (-1,1)x(0,T)                  %%%%%%%
%%%% u=0,                    (x,t) in [R\(-1,1)]x(0,T)              %%%%%%% 
%%%% u(0)=u_0,                x in (-1,1)                           %%%%%%%
%%%%                                                                %%%%%%%                      
%%%% using finite element and the penalized HUM                     %%%%%%%   
%%%% U. Biccari, V. Hernandez-Santamaria, July 2017                 %%%%%%%
%%%% Heavily based on F. Boyer's work                               %%%%%%% 
%%%% v. 0.0                                                         %%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc
separation='==================================================\n';

%prechoixN = [20,50,100];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Load necessary functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global donnees;

m_donnees_control;

maillages_control;
    maillage_uniforme=maill_funcs{1};
    calcul_norme_Eh=maill_funcs{2};
    produitscalaire_Eh=maill_funcs{3};
    calcul_matrices_masse=maill_funcs{4};
    evaluation_simple=maill_funcs{5};

schemas_control;

    init_matrices=schm_func{1};
    solution_forward=schm_func{4};
    solution_adjoint=schm_func{5};
    HUM=schm_func{7};
    grad_conj=schm_func{8};
    
lecture_donnees_control;

resultats=struct();
[resultats(:).time_points]=choixMtemps;
[resultats(:).mesh_points]=choixN;
[resultats(:).penalization]=donnees.phi;
[resultats(:).size_free_sol]=[];
[resultats(:).size_target]=[];
[resultats(:).relative_error]=[];
[resultats(:).optimal_energy]=[];
[resultats(:).cost_of_control]=[];
[resultats(:).mesh_size]=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Conjugate gradient method for the minimization of the cost functional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for Nmaillage=choixN
    
    [maillage]=maillage_uniforme(Nmaillage);
    maillage=calcul_matrices_masse(maillage);
   
    y0=evaluation_simple(maillage.xi,donnees.y0);
    

    target=0*y0;
    
    for Mtemps=choixMtemps
        
        discr.Mtemps=Mtemps;
        matrices=init_matrices(maillage,discr);
        
        soly_libre=solution_forward(y0,zeros(size(y0,1),discr.Mtemps+1),...
            donnees,discr,matrices,maillage);
        
        sec_membre=-soly_libre(:,discr.Mtemps+1);
        
        for epsilon=choix_epsilon
            
            if (isfield(donnees,'phi') && (length(donnees.phi)>0)) 
                h=maillage.pas;
                fprintf('epsilon=phi(h)= %s \n',donnees.phi);
                epsilon=eval(donnees.phi);
            end
        
            [phi0opt,it]=grad_conj(maillage,discr,donnees,matrices,...
                sec_membre,epsilon,donnees.tolerance,'oui',0*sec_membre,y0,soly_libre);
       
            solphi=solution_adjoint(phi0opt,maillage,discr,donnees,matrices);
            controle=matrices.Bstar*solphi;
            
            soly=solution_forward(y0,solphi,donnees,discr,matrices);
            
            cout_controle_temps=zeros(discr.Mtemps,1);

            for j=1:discr.Mtemps
                cout_controle_temps(j)=calcul_norme_Eh(maillage,controle(:,j),0);
            end
            
            fprintf(separation);
            fprintf("Size of the controlled solution at time T: %4.2e\n",...
                     calcul_norme_Eh(maillage,soly(:,discr.Mtemps+1),0));
            fprintf("Size of the uncontrolled solution at time T: %4.2e\n",...
                     calcul_norme_Eh(maillage,soly_libre(:,discr.Mtemps+1),0));
            
            F_eps=1/2*sum(cout_controle_temps.^2)*donnees.T/discr.Mtemps...
                +1/(2*epsilon)*calcul_norme_Eh(maillage,soly(:,discr.Mtemps+1),0).^2;
            fprintf('F_eps(v_eps)= %g \n',F_eps)
            
            J_eps=1/2*sum(cout_controle_temps.^2)*donnees.T/discr.Mtemps+...
            epsilon/2*calcul_norme_Eh(maillage,phi0opt,0)^2+...
            produitscalaire_Eh(maillage,solphi(:,1),y0,0);
            
            fprintf('-J_eps(q_eps)= %g \n',J_eps);
            
            fprintf('F_(v_opt)~J(mu_opt)= %g \n',abs(F_eps+J_eps)/(abs(F_eps)+abs(J_eps)));  
            
             resultats.size_target(end+1)=calcul_norme_Eh(maillage,...
            soly(:,discr.Mtemps+1),0);
        resultats.size_free_sol(end+1)=calcul_norme_Eh(maillage,...
            soly_libre(:,discr.Mtemps+1),0);
        resultats.relative_error(end+1)=abs(F_eps+J_eps)/(abs(F_eps)...
            +abs(J_eps));
        resultats.optimal_energy(end+1)=F_eps;
        resultats.cost_of_control(end+1)=...
            sqrt(sum(cout_controle_temps.^2)*donnees.T/discr.Mtemps);
        resultats.mesh_size(end+1)=h;
           
        end
    end
end

error('aaa')

loglog(resultats.mesh_size,resultats.size_target,'-s',...
    resultats.mesh_size,resultats.cost_of_control,'-s',...
    resultats.mesh_size,resultats.optimal_energy,'-s','LineWidth',2,...
                       'MarkerSize',8)
                   xlabel('Mesh size: h');
sl_tar=log(resultats.size_target(end-1)/resultats.size_target(end))/...
    log(resultats.mesh_size(end-1)/resultats.mesh_size(end));
sl_control=log(resultats.cost_of_control(end-1)/resultats.cost_of_control(end))/...
    log(resultats.mesh_size(end-1)/resultats.mesh_size(end));
sl_energy=log(resultats.optimal_energy(end-1)/resultats.optimal_energy(end))/...
    log(resultats.mesh_size(end-1)/resultats.mesh_size(end));
legend("y(T) "+num2str(sl_tar,'%4.2f'),"Cost of control "+num2str(sl_control,'%4.2f'),...
    "Optimal energy "+num2str(sl_energy,'%4.2f'),'Location','best');

%***********************

%***CHECKING THE SYMETRY

%***********************

 

psi=rand(size(y0,1),1);
psitilde=rand(size(y0,1),1);

Lambda_psi=HUM(psi,maillage,discr,donnees,matrices);
Lambda_psitilde=HUM(psitilde,maillage,discr,donnees,matrices);

disp(produitscalaire_Eh(maillage,psi,Lambda_psitilde,0))
disp(produitscalaire_Eh(maillage,psitilde,Lambda_psi,0))
disp(produitscalaire_Eh(maillage,psi,Lambda_psitilde,0)-produitscalaire_Eh(maillage,psitilde,Lambda_psi,0))