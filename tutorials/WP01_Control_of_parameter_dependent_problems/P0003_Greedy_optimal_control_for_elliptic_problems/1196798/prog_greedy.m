%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Greedy + turnpike                                              %%%%%%%
%%%% Elliptic case:  1-D and 2-D                                    %%%%%%%
%%%% Joint work with M. Lazar and E. zuazua                         %%%%%%%
%%%% Heavily based on F. Boyer's work                               %%%%%%% 
%%%% v. 1.1                                                         %%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
clc
separation='==================================================\n';

prechoixN = [50];

%%% ****************************
%%% Load necessary functions
%%% ****************************

global donnees;

m_donnees;

maillages;
    maillage_uniforme=maill_funcs{1};
    calcul_norme_Eh=maill_funcs{2};
    produitscalaire_Eh=maill_funcs{4};
    calcul_matrices_masse=maill_funcs{6};
    evaluation_simple=maill_funcs{7};

schemas_greedy;

    init_matrices=schm_func{1};
    solution_forward=schm_func{7};
    solution_adjoint=schm_func{9};
    HUM=schm_func{11};
    grad_conj=schm_func{12};
lecture_donnees_turnpike;

%%% ****************************
%%% Greedy control:
%%% Offline part
%%% ****************************

Nmaillage=choixN;

 

[maillage]=maillage_uniforme(Nmaillage);
maillage=calcul_matrices_masse(maillage);

switch donnees.dim
        case '1d'
        yd=evaluation_simple(maillage.xi,donnees.y_d);
        case '2d'
            yd=donnees.y_d(maillage.xi,maillage.yj);
            yd=reshape(yd,maillage.N*maillage.N,1);
end
    
sec_membre=yd;

  nu=linspace(donnees.nu_min,donnees.nu_max,...
              donnees.k+1);

norm_r=zeros(donnees.k+1,1);

switch donnees.surrogate
    case 'vectorial'
        if donnees.dim=='1d'
            r=zeros(2*maillage.N,donnees.k+1);
        elseif donnees.dim=='2d'
            r=zeros(2*maillage.N^2,donnees.k+1);
        end
    otherwise
        if donnees.dim=='1d'
            r=zeros(maillage.N,donnees.k+1);
        elseif donnees.dim=='2d'
            r=zeros(maillage.N^2,donnees.k+1);
        end
end

       
%%*** Computing the free-solution

for j=1:1:donnees.k+1
    matrices = init_matrices(nu(j),maillage);
    switch donnees.surrogate
        case 'regular' 
            free_sol(:,j)=matrices.B*solution_adjoint...
                            (-donnees.beta*yd,donnees,matrices);
            r(:,j)=-free_sol(:,j);
            norm_r(j)=calcul_norme_Eh(maillage,r(:,j),0);
        case 'vectorial'
            if donnees.dim=='1d'
                free_sol(:,j)=[ zeros(maillage.N,1) ; donnees.beta*yd ];
            else
                free_sol(:,j)=[ zeros(maillage.N^2,1) ; donnees.beta*yd ];
            end
            r(:,j)=-free_sol(:,j);
            if donnees.dim=='1d'
            norm_r(j)=...
                sqrt(produitscalaire_Eh(maillage,...
                 free_sol(1:maillage.N,j),free_sol(1:maillage.N,j),0)...
                 +produitscalaire_Eh(maillage,free_sol(maillage.N+1:end,j),...
                 free_sol(maillage.N+1:end,j),0));
            else
            norm_r(j)=...
                sqrt(produitscalaire_Eh(maillage,...
                 free_sol(1:maillage.N^2,j),free_sol(1:maillage.N^2,j),-1)...
                 +produitscalaire_Eh(maillage,free_sol(maillage.N^2+1:end,j),...
                 free_sol(maillage.N^2+1:end,j),-1));
            end
        otherwise
            error('Invalid surrogate')
    end
    
end


[argvalue, argmax] = max(norm_r);
par_greedy(1)=argmax;
nu_sel(1)=nu(argmax);

m=1; sigma(1)=2;

nu_iter=nu; %% to count iterations
nu_cont=nu; %% for control
controle=cell(1,donnees.k+1);
       
%%**para debug
% error('toto')

% **para debug
% error('toto')

tic;
c_1=datestr(now);
pi=zeros(size(yd,1),1);
yi=zeros(size(yd,1),1);

while m<donnees.k+1 && sigma(max(1,m-1))>donnees.eps
    
    clear proj 
    clear py_proj
    
    matrices = init_matrices(nu_iter(par_greedy(m)),maillage);
    
    [muopt,it]=grad_conj(maillage,donnees,matrices,sec_membre,...
                         donnees.tolerance,'oui',0*sec_membre);
                   
    solp=solution_adjoint(-muopt,donnees,matrices);
    soly=solution_forward(-solp,donnees,matrices);
    
%     %%% paper
%     
%     pi=pi+solp;
%     pia=orth(pi)\pi;
%     yi=yi+soly;
%     yi=orth(yi);
%     
%     %%%
     
    switch donnees.surrogate
        case 'vectorial'
           opt_sel(:,m)=[solp;soly];
           controle{find(nu==nu_iter(par_greedy(m)))}=-[solp;-soly];
           alpha_values{find(nu==nu_iter(par_greedy(m)))}=1;
        otherwise
           opt_sel(:,m)=solp;
           controle{find(nu==nu_iter(par_greedy(m)))}=-solp;
           alpha_values{find(nu==nu_iter(par_greedy(m)))}=1;
    end
    
    for j=1:1:size(nu_iter,2)
        
        matrices = init_matrices(nu_iter(j),maillage);
        
        switch donnees.surrogate   
            case 'regular'  
                sol_y_nu=...
                    solution_forward(-matrices.B*solp,donnees,matrices);
                sol_p_nu=...
                    solution_adjoint(sol_y_nu,donnees,matrices);
                
                grad(:,m,find(nu==nu_iter(j)))...
                    =-matrices.B*solp+donnees.beta*matrices.B*sol_p_nu;
                
                proj(:,j)=...
                    projection(r(:,j),grad(:,:,find(nu==nu_iter(j))));
                
            case 'vectorial'  
                
                res1=matrices.A*soly+matrices.B*solp;
                res2=matrices.A*solp-donnees.beta*soly;
                
                grad(:,m,find(nu==nu_iter(j)))=[res1;res2];
                
                y_vector(:,m,find(nu==nu_iter(j)))=...
                    [matrices.A*soly;-donnees.beta*soly];
                p_vector(:,m,find(nu==nu_iter(j)))=...
                    [matrices.B*solp;matrices.A*solp];
                
                py_proj(:,j)=...
                    projection(r(:,j),[p_vector(:,:,find(nu==nu_iter(j))),...
                    y_vector(:,:,find(nu==nu_iter(j)))]);
                
%                 %%% como viene en el paper
%                 
%                 res=[matrices.A*yi+matrices.B*pi;matrices.A*pi-donnees.beta*yi];
%                 
%                 err(:,m)=norm(res);
%                 
%                 
%                 %%%
                
                proj(:,j)=...
                    projection(r(:,j),grad(:,:,find(nu==nu_iter(j))));
        end
        
        if j==par_greedy(m)
            switch donnees.surrogate
                case 'vectorial'
                 if donnees.dim=='1d'
                 norm_r(j)=...
                    sqrt(produitscalaire_Eh(maillage,r(1:maillage.N,j)...
                    -py_proj(1:maillage.N,j),r(1:maillage.N,j)...
                    -py_proj(1:maillage.N,j),0)+...
                    produitscalaire_Eh(maillage,r(maillage.N+1:end,j)...
                    -py_proj(maillage.N+1:end,j),r(maillage.N+1:end,j)...
                    -py_proj(maillage.N+1:end,j),0));
                 else
                 norm_r(j)=...
                    sqrt(produitscalaire_Eh(maillage,r(1:maillage.N^2,j)...
                    -py_proj(1:maillage.N^2,j),r(1:maillage.N^2,j)...
                    -py_proj(1:maillage.N^2,j),-1)+...
                    produitscalaire_Eh(maillage,r(maillage.N^2+1:end,j)...
                    -py_proj(maillage.N^2+1:end,j),r(maillage.N^2+1:end,j)...
                    -py_proj(maillage.N^2+1:end,j),-1));
                 end                                                                                        
                otherwise 
                norm_r(j)=calcul_norme_Eh(maillage,r(:,j)-proj(:,j),0); 
            end
        else
            switch donnees.surrogate
                case 'vectorial'
                if donnees.dim=='1d'
                 norm_r(j)=...
                    sqrt(produitscalaire_Eh(maillage,r(1:maillage.N,j)...
                    -py_proj(1:maillage.N,j),r(1:maillage.N,j)...
                    -py_proj(1:maillage.N,j),-1)+...
                    produitscalaire_Eh(maillage,r(maillage.N+1:end,j)...
                    -py_proj(maillage.N+1:end,j),r(maillage.N+1:end,j)...
                    -py_proj(maillage.N+1:end,j),-1));
                 else
                 norm_r(j)=...
                    sqrt(produitscalaire_Eh(maillage,r(1:maillage.N^2,j)...
                    -py_proj(1:maillage.N^2,j),r(1:maillage.N^2,j)...
                    -py_proj(1:maillage.N^2,j),-1)+...
                    produitscalaire_Eh(maillage,r(maillage.N^2+1:end,j)...
                    -py_proj(maillage.N^2+1:end,j),r(maillage.N^2+1:end,j)...
                    -py_proj(maillage.N^2+1:end,j),-1));
                 end
                otherwise
                norm_r(j)=calcul_norme_Eh(maillage,r(:,j)-proj(:,j),0); 
            end
                
            
        end
        
        if norm_r(j)<donnees.eps
            nu_iter(j)=0;
        end       
    end
    
     %norm_r'
     [error, err_value] = argmax_m(norm_r);
     sigma_approx(m)=err_value
     
%     nu_iter
      
    ind=find(nu_iter==0);
    
    for i=ind
        %%%*** functional approximation
        %if i ~= par_greedy(m)
            matrices = init_matrices(nu(find(nu==nu_cont(i))),maillage);
            
            switch donnees.surrogate
                case 'vectorial'
                    alpha=([p_vector(:,:,find(nu==nu_cont(i))), ...
                                   y_vector(:,:,find(nu==nu_cont(i))) ])...
                                   \py_proj(:,i);
                    %alpha=(grad(:,:,find(nu==nu_cont(i))))\proj(:,i);
                    alpha_values{find(nu==nu_cont(i))}=alpha;
                    alpha_ind=size(alpha,1)/2;
                otherwise
                    alpha=(grad(:,:,find(nu==nu_cont(i))))\proj(:,i);
                    alpha_values{find(nu==nu_cont(i))}=alpha;
                    alpha_ind=size(alpha,1);
            
            end
            
            switch donnees.dim
                case '1d'
                    controle_temp=zeros(maillage.N,1);
                case '2d'
                    controle_temp=zeros(maillage.N^2,1);
            end
            
            for j=1:1:alpha_ind
                if donnees.dim=='1d'
                    controle_temp=controle_temp+...
                        alpha(j)*opt_sel(1:maillage.N,j);
                elseif donnees.dim=='2d'
                    controle_temp=controle_temp+...
                        alpha(j)*opt_sel(1:maillage.N^2,j);
                end
            end
            controle{find(nu==nu_cont(i))}=-(controle_temp);
        %end   
    end
       
    
    nu_iter(ind) = [];
    r(:,ind)=[];
    norm_r(ind)=[];
    nu_cont(ind)=[];
    
        
    if size(nu_iter,2)==0 
        break
    end
    
    
    [argmax, argvalue] = argmax_m(norm_r);
    
    par_greedy(m+1)=argmax;
    
    sigma(m)=argvalue;
    
    nu_sel(m+1)=nu_iter(par_greedy(m+1))
    
    m=m+1;
    
    
end

% check if any repeated parameter
anyRepeated = ~all(diff(sort(nu_sel)));

if anyRepeated == 1
    error ('Repeated parameters')
end

toc;
c_2=datestr(now);

%**para debug
error('toto')

%***********************
%***CHECKING THE SYMETRY
%***********************

psi=rand(size(yd,1),1);
psitilde=rand(size(yd,1),1);

Lambda_psi=HUM(psi,donnees,matrices);
Lambda_psitilde=HUM(psitilde,donnees,matrices);

disp(produitscalaire_Eh(maillage,psi,Lambda_psitilde,0))
disp(produitscalaire_Eh(maillage,psitilde,Lambda_psi,0))
disp(produitscalaire_Eh(maillage,psi,Lambda_psitilde,0)...
     -produitscalaire_Eh(maillage,psitilde,Lambda_psi,0))

 function [y]=projection(v,B)
    g=orth(B);
    [m,n]=size(g);
    y=zeros(m,1);
    for j=1:1:n
        y=y+dot(v,g(:,j))*g(:,j);
    end
 end
 
 function[j,maks]=argmax_m(y)
 j=1;
 maks=y(1);
 for i=2:1:length(y)
     if y(i) > maks
         maks=y(i);
         j=i;
     end
 end
 end


