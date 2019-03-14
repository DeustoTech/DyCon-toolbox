%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Paramaters for the time discretization 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

discr=cell(0);

discr{(end+1)} = struct('methode','elliptic',...
                        'Mtemps',0,...
                        'theta',0....
                       );

discr{(end+1)} = struct('methode','euler',...
                        'Mtemps',100,...
                        'theta',0....
                       );	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Reading of the datas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(separation);
fprintf('Choice of the test case:\n');

fprintf(separation);
if exist('prechoix','var')
    choix=prechoix;
    printf("Choice number %g\n",choix);
else
        for i=1:length(cas_test)
                    temp=cell2mat(cas_test(1,i));
                    fprintf('%d) %s\n',i,temp.nom);
                    clear temp i
        end
        
        choix=input('Choose among the cases proposed: ');
        while double(choix)>length(cas_test) 
            choix=input('Choose among the cases proposed: ');
        end            
end
choix=double(choix);

donnees=cell2mat(cas_test(choix));

if ~isfield(donnees,'tolerance') 
    donnees.tolerance=default_tolerance;
end

fprintf(separation);

choix_maillage=-1;
if isfield(donnees,'maillage') 
    switch donnees.maillage 
    case 'uniforme'
        choix_maillage=1;
        fprintf("Uniform mesh \n");
    end
end

switch choix_maillage
case 1
    donnees.maillage="uniforme";
end
 
fprintf(separation);

if(exist('prechoixN'))
    choixN=prechoixN;
else
    choixN=input('Number of dicretization points in space :');
    choixN=floor(double(choixN)); 
end

fprintf(separation);
choix=-1;
if isfield(donnees,'methode') 

    for i=1:length(discr) 
        if strcmp(discr{i}.methode,donnees.methode)
            choix=i;
            fprintf('Scheme in time: %s \n',donnees.methode);
        end
    end
end

if (choix==-1) 

    fprintf('Choice of the scheme in time:\n');
    for i=1:length(discr)
        fprintf('%d) %s\n',i,discr{i}.methode);
    end

    choix=-1;
    while ((choix)<=0) || ((choix)>length(discr))
        choix=input('Choose:');
    end
    choix=floor(double(choix)); 

end

discr=discr{choix};

if strcmp(discr.methode,'elliptic')  
    choixMtemps=0;
   
else
   fprintf(separation);
    if(exist("prechoixT"))
        choixMtemps=floor(double(prechoixT));
    else        
        choixMtemps=input('Number of discretization points in time:');
        choixMtemps=floor(double(choixMtemps));
    end
end

if ~isfield(donnees,'pt_fixe_it_max')
    donnees.pt_fixe_it_max=50;
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Chioce of the penalization parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(separation);

if ((isfield(donnees,'phi')) && (length(donnees.phi)>0)) 
    choix_epsilon=['1'];
elseif (isfield(donnees,'epsilon')) 
    choix_epsilon=donnees.epsilon;
else
    choix_epsilon=input('Choice of epsilon :');
end
