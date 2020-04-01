function tutorials2blog(name,varargin)
     p = inputParser;
     
     addRequired(p,'name')
     
      addOptional(p,'path_documentation','/home/djoroya/Documentos/GitHub/CCM/Webs/dycon-toolbox-documentation')

     
     parse(p,name,varargin{:})
    
    path_documentation = p.Results.path_documentation;

    %%
    
    path_file = which(name);
    path_file = replace(path_file,'\','/');
    path_file_cell = strsplit(path_file,'/');
    
    path_folder = strjoin(path_file_cell(1:(end-1)),'/');
    
    %% Crear el nuevo .m sin $$ y $ 
    INFile = fopen(path_file,'r');
    INFile_content = fscanf(INFile,'%c');
    
    INFile_content = replace(INFile_content,'$$','dollars-dollars');
    INFile_content = replace(INFile_content,'$','dollars');
    
    
    OUTFile = fopen([path_folder,'/copiaRM.m'],'w');
    fwrite(OUTFile,INFile_content);
    fclose(OUTFile);
    
    publishreadme('copiaRM',path_folder,false)
    delete([path_folder,'/copiaRM.m'])
    delete([path_folder,'/copiaRM.html'])

    %% load Metadata
    INMetadata = fopen([path_folder,'/metadata.txt'],'r');
    INMetadata_content = fscanf(INMetadata,'%c');
    fclose(INMetadata);
    % number
    foldercell = strsplit(path_file_cell{end-1},'_');
    number = foldercell{1};
    % obtain module
    modulecell = path_file_cell{end-2};
    module = strsplit(modulecell,'_');
    module = module{1};
    % Create name of .md
    path_md = [path_documentation,'/_posts/tutorials/',module];
    file_md = [path_documentation,'/_posts/tutorials/',module,'/0001-01-01-',number,'.md'];
    delete(file_md);
    %% load copiaRM.md
    INcopiaRM = fopen([path_folder,'/copiaRM.md'],'r');
    INcopiaRM_content = fscanf(INcopiaRM,'%c');
    fclose(INcopiaRM)    
    delete([path_folder,'/copiaRM.md'])

 
    %%
    INcopiaRM_content = strsplit(INcopiaRM_content,[newline,newline]);
    INcopiaRM_content = join(INcopiaRM_content(2:end),[newline,newline]);
    INcopiaRM_content = INcopiaRM_content{:};
    INcopiaRM_content = replace(INcopiaRM_content,'# ./imgs-matlab/copiaRM','');
    
    %INcopiaRM_content = replace(INcopiaRM_content,'|','\vert');
    INcopiaRM_content = replace(INcopiaRM_content,'dollars-dollars','$$');
    INcopiaRM_content = replace(INcopiaRM_content,'dollars','$');
    INcopiaRM_content = replace(INcopiaRM_content,'&amp;','&');
    INcopiaRM_content = replace(INcopiaRM_content,'&lt;','<');
    INcopiaRM_content = replace(INcopiaRM_content,'&gt;','>');
    INcopiaRM_content = replace(INcopiaRM_content,'&nbsp;',' ');
    INcopiaRM_content = replace(INcopiaRM_content,'](extra-data',[']({{site.url}}/{{site.baseurl}}/assets/imgs/tutorials/',module,'/',number]);
    INcopiaRM_content = replace(INcopiaRM_content,'](./imgs-matlab',[']({{site.url}}/{{site.baseurl}}/assets/imgs/tutorials/',module,'/',number]);
    INcopiaRM_content = replace(INcopiaRM_content,'%','%%');

    %%
    if ~exist(path_md,'dir')
        mkdir(path_md);
    end
    
    OUTMD = fopen(file_md,'a');
    fprintf(OUTMD,'---\n');
    fprintf(OUTMD,INMetadata_content);
    fprintf(OUTMD,'layout: tutorial\n');
    fprintf(OUTMD,['matlab: ',name,'\n']);

    fprintf(OUTMD,['categories: [tutorial,',module,']\n']);
    fprintf(OUTMD,'---\n');
    fwrite(OUTMD,INcopiaRM_content);
    fclose(OUTMD);
    %% imagenes 
    img_path = [path_documentation,'/assets/imgs/tutorials/',module,'/',number];
    if ~exist(img_path)
        mkdir(img_path);
    end
    if exist([path_folder,'/extra-data'],'dir')
        copyfile([path_folder,'/extra-data/*'],[img_path,'/']);
    end
    if exist([path_folder,'/imgs-matlab'],'dir')
        copyfile([path_folder,'/imgs-matlab/*'],[img_path,'/']);
    end
    
 end

