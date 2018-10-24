
%%***********************************************************************
%%*******  Discretization of the domain \Omega=(0,1)
%%*******  
%%*******
%%***********************************************************************


%%***********************************************************************
%%********           Maillage uniforme 1D
%%***********************************************************************


maill_funcs=localfunctions;



function [maillage] = maillage_uniforme(N)
    
    global donnees
    switch donnees.dim
        case '1d'
    
        x=linspace(0,1,N+2)';

        ximd(1:N) = (x(2:N+1)+x(1:N))/2 ;      %** x_{i-1/2} point a gauche du point x_i
        xipd(1:N) = (x(2:N+1)+x(3:N+2))/2;     %** x_{i+1/2} point a droite du point x_i
                                               %** md = moins demi, pd = plus demi
        himd=x(2:end-1)-x(1:end-2);
        hipd=x(3:end)-x(2:end-1);
        hi=0.5*(hipd+himd);
        x=x(2:end-1);

        maillage=struct('nom','maillage uniforme',...
        'dim',1,...
        'xi',x,...
        'xipd',xipd',...
        'ximd',ximd',...
        'himd',himd,...
        'hipd',hipd,...
        'hi',hi,...
        'pas',max(hi),...
        'N',N);

        case '2d'
            
        x=linspace(0,1,N+2)';
        y=linspace(0,1,N+2)';
        
        ximd(1:N) = (x(2:N+1)+x(1:N))/2 ;
        xipd(1:N) = (x(2:N+1)+x(3:N+2))/2;
        
        yjmd(1:N) = (y(2:N+1)+y(1:N))/2 ;
        yjpd(1:N) = (y(2:N+1)+y(3:N+2))/2;

        hi=x(2)-x(1);

        x=x(2:end-1);
        y=y(2:end-1);
        
        [X,Y]=meshgrid(x,y);
        [Ximd,Yjmd]=meshgrid(ximd,yjmd);
        [Xipd,Yjpd]=meshgrid(xipd,yjpd);
        
        X=X'; Y=Y'; 
        Ximd=Ximd'; Yjmd=Yjmd';
        Xipd=Xipd'; Yjpd=Yjpd';
        
        maillage=struct('nom','maillage uniforme',...
        'dim',2,...
        'hi',hi,...
        'xi', X,...
        'yj', Y,...
        'ximd', Ximd,...
        'xipd', Xipd,...
        'yjmd', Yjmd,...
        'yjpd', Yjpd,...
        'pas',max(hi),...
        'N',N);   
    end

end

%%***********************************************************************
%%********       Calcul de la norme dans l'espace d'etat discret Eh
%%***********************************************************************

function [n]=calcul_norme_Eh(m,vecteur,s)

    n = sqrt(produitscalaire_Eh(m,vecteur,vecteur,s));

end

%%***********************************************************************
%%********       Calcul de la norme dans l'espace de controle discret Uh
%%***********************************************************************

function [n]=calcul_norme_Uh(m,vecteur)

    n = sqrt(produitscalaire_Uh(m,vecteur,vecteur));

end

%%***********************************************************************
%%********       Calcul du produit scalaire dans l'espace d'etat discret Eh
%%***********************************************************************

%** produitscalaire_Eh calcule la norme : L^2 si s=0
%**                                       H^1_0 si s=1
%**                                       H^{-1} si s=-1                                         
function [n]=produitscalaire_Eh(maill,vecteur,vecteur2,s)

    switch s
        case 0  
            n=vecteur'*maill.H_Eh*vecteur2; %* norme L2
        case -1
            n=vecteur'*maill.H_Eh*(maill.MDelta\vecteur2);
    end

    end

%%***********************************************************************
%%********       Calcul du produit scalaire dans l'espace de controle discret Uh
%%***********************************************************************

function [n]=produitscalaire_Uh(maill,vecteur,vecteur2)
    switch donnees.type_controle
        case 1 
            n=vecteur'*maill.H_Uh*vecteur2;
    end
end

%************************************************************************
%*********       Calcul des matrices de masse 1D ou 2D
%************************************************************************

function [maill]=calcul_matrices_masse(m)

    global donnees;
    maill=m;
        
    switch donnees.dim
        case '1d'
            bloc=sparse(maill.N,maill.N);
            maill.H_Eh=sparse(maill.N*donnees.nbeq,maill.N*donnees.nbeq);
            maill.H_Uh=sparse(maill.N*donnees.nbc,maill.N*donnees.nbc);
            
            for i=1:maill.N
                bloc(i,i)=maill.hi(i);
            end
            
            for j=1:donnees.nbeq
                maill.H_Eh( 1+(j-1)*maill.N:j*maill.N , 1+(j-1)*maill.N:j*maill.N )=bloc;
            end
            
            for j=1:donnees.nbc
                maill.H_Uh( 1+(j-1)*maill.N:j*maill.N , 1+(j-1)*maill.N:j*maill.N )=bloc;
            end 
        case '2d' 
            maill.H_Eh=maill.pas^2*speye(maill.N^2);
            maill.H_Uh=maill.H_Eh;
            
            maill.MDelta=construction_laplacien(maill);
    end
   

end

% %***********************************************************************
% %********     Fonctions pour evaluer des expressions en des points du maillage
% %***********************************************************************
% 
% 
% ** Evaluation d'une vraie fonction
% function [v]=eval_fonction(points,f)
%     v=zeros(size(points,1),1);
%     for i=1:size(points,1)
%         v(i)=f(points(i,1),points(i,2));
%     end
% end
%  
% ** Evaluation d'une expression qui peut être :
% **   Une fonction scilab
% **   Une constante
% **   Une chaine de caracteres

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

% ** Evaluation d'une liste d'expressions
% function [v]=evaluation(points,p,f)
% 
%     if typeof(f)=='list' then
%         p=length(f);
% 
%         n=size(points,1);
%         v=zeros(n*p,1);
%         for j=1:p
%             v(1+(j-1)*n : j*n)=evaluation_simple(points,f(j));
%         end;
% 
%     else
% 
%         v=evaluation_simple(points,f);
% 
%     end;
% 
% end
% 
% %** Idem pour les fonctions dépendant du temps
% function [v]=evaluation_simple_un_temps(t,points,f)
%     v=zeros(length(points),1);
% 
%     switch isa(f,'constant')
%         //   case 'function' then v=feval(points,f);
%     case 'constant' then v=f*(1+v);
%     case 'string'   then 
%         x=points;
%         v=evstr(f);
%         if (length(v)==1) then
%             v=v*ones(length(points),1);
%         end;
%     else 
%         //disp('Erreur dans le type d''argument passe a evaluation_simple ="+...
%         //" '+typeof(f));
%         abort;
%     end;
% end
% 
%** Idem pour les fonctions dépendant du temps
function [v]=constant_evalution_time(t,points,f)

    v=zeros(length(points),length(t));

    for k=1:length(t)
        v(:,k)=f;
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%   Calcul du produit scalaire dans l'espace d'etat discret Vh 
%%%%%%%%   constuct norm in L^2(0,T;Eh)
%%%%%%%%   Step 1: obtain norm in Eh as a function of time
%%%%%%%%   Step 2: sum and obtain the norm in L^(0,T)       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [n]=produitscalaire_Vh(maill,vecteur,vecteur2,s)
    
    global discr;
    global donnees;
    
    escalaire_temps_Vh=zeros(discr.Mtemps+1,1);
    
    for j=1:discr.Mtemps+1
        escalaire_temps_Vh(j)=vecteur(:,j)'*maill.H_Eh*vecteur2(:,j);
    end
    
    prod_escalaire_Vh=sum(escalaire_temps_Vh*donnees.T/discr.Mtemps);
    
    %prod_escalaire_yT=produitscalaire_Eh(maill,vecteur(:,discr.Mtemps+2),...
        %vecteur2(:,discr.Mtemps+2),s);
    %n=prod_escalaire_Vh+prod_escalaire_yT;  %% for future implementation
    
    n=prod_escalaire_Vh;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%      Calcul de la norme dans l'espace d'etat discret Vh=Qh x Eh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [n]=calcul_norme_Vh(m,vecteur,s)

    n = sqrt(produitscalaire_Vh(m,vecteur,vecteur,s));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Construction de la matrice -Laplacien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MDelta]=construction_laplacien(maillage)

    I_c = speye(maillage.N);
        e_c = ones(maillage.N,1);
        T_c = spdiags([-e_c 4*e_c -e_c],[1 0 -1],maillage.N,maillage.N);
        S_c = spdiags([-e_c -e_c],[1 -1],maillage.N,maillage.N);
        A_c = (kron(I_c,T_c) + kron(S_c,I_c))./(maillage.pas^2);
        
        MDelta=A_c; 
end
