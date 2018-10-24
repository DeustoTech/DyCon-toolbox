
fprintf(separation);
fprintf('Choix du cas test :\n');

fprintf(separation);
if exist('prechoix','var')
    choix=prechoix;
    printf("Choix numero %g\n",choix);
else
        for i=1:length(cas_test)
                    temp=cell2mat(cas_test(1,i));
                    fprintf('%d) %s\n',i,temp.nom);
                    clear temp i
        end
        
        choix=input('Faites votre choix parmi les cas tests proposés : ');
        while double(choix)>length(cas_test) 
                %* Afin de ne pas pouvoir selectionner un type de donnée autre que ceux proposés
            choix=input('Faites votre choix parmi les cas tests proposés : ');
        end            
end
choix=double(choix);

%* Chargement des donnees choisies par l'utilisateur

donnees=cell2mat(cas_test(choix));

% %* On fixe la tolerance du GC :
% 
if ~isfield(donnees,'tolerance') 
    donnees.tolerance=default_tolerance;
end
% 
% if (type_controle==0) & (~isfield(donnees,'controle_bord')) then
%     printf('Vous n''avez pas spécifié la matrice B. Fin du programme');
%     abort
% end;
% 
% %* Si on est en mode sans graphisme :
% 
% if ~isfield(donnees,'trace') then
%     donnees.trace=%F;
% end;
% 
% if ~isfield(donnees,'atracer') then
%     donnees.atracer=struct('qF',%F,'sol',%F,'cont',%F,'cout',%F,'sol_temps',%F); //Manquait sol_temps
% else
%     if ~isfield(donnees.atracer,'qF') then
%         donnees.atracer.qF=%F;
%     end;
%     if ~isfield(donnees.atracer,'sol') then
%         donnees.atracer.sol=%F;
%     end;
%     if ~isfield(donnees.atracer,'cont') then
%         donnees.atracer.cont=%F;
%     end;
%     if ~isfield(donnees.atracer,'cout') then
%         donnees.atracer.cout=%F;
%     end;
%     if ~isfield(donnees.atracer,'sol_temps') then
%         donnees.atracer.sol_temps=%F;
%     end;
% end;
% 
% try
%     if getscilabmode()=="NWNI" then
%         donnees.trace=%F;
%         donnees.animation=%F;
%     end;
% end;

%****************************
%** choix du type de maillage
%****************************

fprintf(separation);

choix_maillage=-1;
if isfield(donnees,'maillage') 
    switch donnees.maillage 
    case 'uniforme'
        choix_maillage=1;
        fprintf("Maillage uniforme \n");
    case 'aleatoire'
        choix_maillage=2;
        fprintf("Maillage aléatoire \n");
    case 'raffine'
        choix_maillage=3;
        fprintf("Maillage raffiné \n");
    end
end

% if (choix_maillage==-1) then
% 
%     printf('Choix du maillage :\n');
%     printf('1) uniforme\n');
%     printf('2) aleatoire\n');
%     printf('3) raffine\n');
%     while (int(choix_maillage)<=0) | (int(choix_maillage)>3)
%         choix_maillage=input("Faites votre choix :");
%     end;
%     choix_maillage=int(choix_maillage);
% end;
 
switch choix_maillage
case 1
    donnees.maillage="uniforme";
case 2
    donnees.maillage="aleatoire";
case 3
    donnees.maillage="raffine";
end
 
%** choix du nombre de mailles

fprintf(separation);
%**prechoixN=[100];
if(exist('prechoixN'))
    choixN=prechoixN;
    %**printf("prechoix nombre de mailles : %g \n",prechoixN);
else
    choixN=input('Nombre de mailles :');
    choixN=floor(double(choixN)); %** ne fonctionne pas comme floor ou ceil. Enleve la partie décimale.
end

%** Choix du schéma en temps

% printf(separation);
% choix=-1;
% if isfield(donnees,'methode') then
% 
%     for i=1:length(discr) // discr : structure pour gérer le pas de temps
%         if (discr(i).methode==donnees.methode) then
%             choix=i;
%             printf("Schéma en temps :"+donnees.methode+"\n");
%         end;
%     end;
% end;
% 
% if (choix==-1) then
% 
%     printf('Choix du schéma en temps :\n');
%     for i=1:length(discr)
%         printf('%d) %s\n',i,discr(i).methode);
%     end;
% 
%     choix=-1; //inutile
%     while (int(choix)<=0) | (int(choix)>length(discr))
%         choix=input("Faites votre choix :");
%     end;
%     choix=int(choix); // ou dans le while : | int(choix)<>choix
% 
% end;
% 
% // Chargement des options de discrétisation
% 
% discr=discr(choix);
% 
% // choix du nombre de points en temps
% 
% if ((discr.methode=="semi") | (discr.methode=="spectral"))  then
%     choixMtemps=[1];
%     //  discr.Mtemps=1;
% else
%    printf(separation);
%    // prechoixT=[100];
%     if(exists("prechoixT"))
%         choixMtemps=int(prechoixT);
%         //printf("prechoix nombre de points en temps : %g \n",prechoixT);
%     else        
%         choixMtemps=input('Nombre de points en temps :');
%         choixMtemps=int(choixMtemps);
%         //  discr.Mtemps=int(Mtemps);
%     end;
% end; 

%** On fixe le nb d'iterations max

if ~isfield(donnees,'pt_fixe_it_max')
    donnees.pt_fixe_it_max=50;
end
 
% // On fixe le parametre de relaxation si nécessaire
% 
% choix_relaxation=[1];
% 
% if isfield(donnees,'nonlinearite') then
%     choix_relaxation=-1;
%     while ((min(choix_relaxation)<=0) | (max(choix_relaxation)>1)) then
%         if ~isfield(donnees,'relaxation') then
%             printf(separation);
%             choix_relaxation=input('Parametres de relaxation :');
%         end;
%     end;
% end;
% 
% 
% /////////////////////////////////////////////////////////
% ////  On fixe le paramètre de pénalisation
% /////////////////////////////////////////////////////////
% 
% printf(separation);
% 
% if ((isfield(donnees,'phi')) & (length(donnees.phi)>0)) then
%     choix_epsilon=['1'];
% elseif (isfield(donnees,'epsilon')) then
%     choix_epsilon=donnees.epsilon;
% else
%     choix_epsilon=input("Choix de epsilon :");
% end;
% // choix_epsilon utilisé dans prog.sce

if ((isfield(donnees,'phi')) && (length(donnees.phi)>0)) 
    choix_epsilon=['1'];
end
