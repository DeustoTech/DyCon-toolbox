function m2md(file)

    all = strsplit(file,'_');
    class = all{1};
    method = all{2};
    
    mainfile        = 'StartDyConToolbox.m';
    pathfile    =  replace(which(mainfile),mainfile,''); 
    %pathfile    = fullfile(pathfile,'docs','03-DynamicsInterface',class);
    pathfile    = fullfile(pathfile,'docs','04-PontryaginProblems',class);

    publishreadme(file,pathfile,false)
    
    pathfile = fullfile(pathfile,file);
    pathfile = [pathfile,'.md'];
    
    output_file = '/home/djoroya/Documentos/GitHub/CCM/Webs/dycon-toolbox-documentation/_includes/examples';
    output_file = fullfile(output_file,class,method);
    output_file = [output_file,'.md'];
    system(['cat ',pathfile,' | grep -v ''# tp''>',output_file]);
end