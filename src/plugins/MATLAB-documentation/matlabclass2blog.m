 function matlabclass2blog(ClassName,FolderDocumentation)
    
    data_class = what(ClassName);
    path_class = data_class(end).path;

    mfiles = data_class(end).m;

    mkdir([FolderDocumentation,'/',ClassName])
    
    FolderDocumentation = [FolderDocumentation,'/',ClassName];
    %% module
    module = strsplit(path_class,'/');
    module = module{end-2};
    module = strsplit(module,'_');
    module = module{1};
    %% Contructor 

    mfile_path = [path_class,'/',ClassName,'.m'];
    help_data = ObtainHelp(mfile_path);
        help_data = replace(help_data,'\','\\');

    %help_data = replace(help_data,newline,' ');
    metadata = metaclass(eval([ClassName,'.empty']));    
    
    %% Properties 
    sp = '   ';
    listofproperties = ['properties:',newline];
    for ipl = metadata.PropertyList'
        if strcmp(ipl.Name,'select')
           continue 
        end
        if ~strcmp(ipl.DefiningClass.Name,ClassName)
            continue
        end
        listofproperties = [listofproperties,sp,ipl.Name,': ',newline];
        
        help_property = help([ClassName,'.',ipl.Name]);
        help_property = strsplit(help_property,newline);
        if length(help_property) <= 2
           continue 
        end
        for index = 1:length(help_property)
            help_property{index} = [sp,sp,help_property{index}];
        end
        help_property = join(help_property,newline);
        help_property = help_property{:};
        
        listofproperties = [listofproperties,help_property,newline];
        
%         if ipl.HasDefault
%            listofproperties = strtrim(listofproperties)
%            text_default = evalc('ipl.DefaultValue');
%            text_default = strsplit(strtrim(text_default),newline);
%            text_default = strtrim(text_default{end});
%            
%            text_default = replace(text_default,'function_handle','function_handle');
%            
%            text_default = replace(text_default,'href=','HREF');
%            text_default = replace(text_default,'<a HREF"matlab:helpPopup function_handle" style="font-weight:bold">function_handle</a>','function_handle');
%            text_default = replace(text_default,'�','x');
%            listofproperties = [listofproperties,newline,sp,sp,sp,'default: ',text_default,newline];
%         end
    end    
    listofproperties = replace(listofproperties,'%',' ');
    
    %% methods 
    listofmethods = ['methods:',newline];
    mkdir([FolderDocumentation,'/methods',])

    for imtd = metadata.MethodList'
       if strcmp(imtd.DefiningClass.Name,ClassName) && ~strcmp(imtd.Name,'empty')
           listofmethods = [listofmethods,sp,imtd.Name,':',newline];
           help_mtd = help([ClassName,'/',imtd.Name]);
            help_mtd = replace(help_mtd,'\','\\');
           %% Create a file for method

           outfile_path = [FolderDocumentation,'/methods/0001-01-01-',imtd.Name,'.md'];
               
            
           if exist(outfile_path,'file')
                delete(outfile_path);
           end
            
           outfile_constructor = fopen(outfile_path,'a');
           fprintf(outfile_constructor,'---\n');
           fprintf(outfile_constructor,['title: ',imtd.Name,'\n']);
           url = ['/documentation/',lower(module),'/',ClassName,'/',imtd.Name];
            
           fprintf(outfile_constructor,'data: \n');
           fprintf(outfile_constructor,help_mtd);
           fprintf(outfile_constructor,['categories: [ documentation , ',module,' , ',ClassName,']']);
           fprintf(outfile_constructor,'\n');
           fprintf(outfile_constructor,['class: ',ClassName,'\n']);
           fprintf(outfile_constructor,'layout: method\n');
           fprintf(outfile_constructor,'---\n');
           fclose(outfile_constructor);

           %%
           help_mtd = strsplit(help_mtd,newline);
           for index_hm = 1:length(help_mtd)
               help_mtd{index_hm} = [sp,sp,help_mtd{index_hm}];
           end
          

          vacio = strip(help_mtd{1},'right');
          n = length(vacio) - length(strip(vacio,'left'));
          ssp = help_mtd{index_hm-1}(1:n);
          
          help_mtd{index_hm} =  [ssp,'url: ',url];

          
          help_mtd = join(help_mtd,newline);
          help_mtd = help_mtd{:};
          listofmethods = strtrim([listofmethods,help_mtd]);
          listofmethods = [listofmethods,newline];
       end
    end
 
    %% HELP file
    help_mfile = ['help_',ClassName];
    path_file = which(help_mfile);
    path_folder = strsplit(path_file,'/');
    path_folder = join(path_folder(1:(end-1)),'/');
    path_folder = path_folder{:};
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
    %% load copiaRM.md
    INcopiaRM = fopen([path_folder,'/copiaRM.md'],'r');
    INcopiaRM_content = fscanf(INcopiaRM,'%c');
    fclose(INcopiaRM)    
    delete([path_folder,'/copiaRM.md'])
    INcopiaRM_content = strsplit(INcopiaRM_content,[newline,newline]);
    INcopiaRM_content = join(INcopiaRM_content(2:end),[newline,newline]);
    INcopiaRM_content = INcopiaRM_content{:};
    INcopiaRM_content = replace(INcopiaRM_content,'# ./imgs-matlab/copiaRM','');
    
    INcopiaRM_content = replace(INcopiaRM_content,'dollars-dollars','$$');
    INcopiaRM_content = replace(INcopiaRM_content,'dollars','$');
    INcopiaRM_content = replace(INcopiaRM_content,'&amp;','&');
    INcopiaRM_content = replace(INcopiaRM_content,'&lt;','<');
    INcopiaRM_content = replace(INcopiaRM_content,'&gt;','>');
    INcopiaRM_content = replace(INcopiaRM_content,'%','%%');
    INcopiaRM_content = replace(INcopiaRM_content,'\','\\');


    
  
    INcopiaRM_content = replace(INcopiaRM_content,'](extra-data',[']({{site.url}}/{{site.baseurl}}/assets/imgs/function/',module,'/']);
    INcopiaRM_content = replace(INcopiaRM_content,'](./imgs-matlab',[']({{site.url}}/{{site.baseurl}}/assets/imgs/',module,'/class/main/',ClassName]);

    %%  
    main_folder = strsplit(FolderDocumentation,'_posts');
    main_folder = main_folder{1};
    path_img = [main_folder,'assets/imgs/',module,'/class/main/',ClassName];
    mkdir(path_img)
    if exist([path_folder,'/imgs-matlab/'])
    copyfile([path_folder,'/imgs-matlab/*'],path_img)
    end
    
    %% Load File
    outfile_path = [FolderDocumentation,'/0001-01-01-Class',ClassName,'.md'];
    if exist(outfile_path,'file')
       delete(outfile_path);
    end
    
    outfile_constructor = fopen(outfile_path,'a');
    
    fprintf(outfile_constructor,'---\n');
    fprintf(outfile_constructor,help_data);
    fprintf(outfile_constructor,'\n');
    fprintf(outfile_constructor,['title: ',ClassName,'\n']);
    fprintf(outfile_constructor,['categories: [documentation, ',module,']\n']);
    fprintf(outfile_constructor,'layout: class\n');
    fprintf(outfile_constructor,'type: constructor\n');
    fprintf(outfile_constructor,listofproperties);
    fprintf(outfile_constructor,listofmethods);
    fprintf(outfile_constructor,'\n');
    fprintf(outfile_constructor,'---\n');
    fprintf(outfile_constructor,INcopiaRM_content);

    fclose(outfile_constructor);
    
    
end


function HelpText = ObtainHelp(path_file)

    help_data   = help(path_file);
    help_data = strsplit(help_data,'Reference page');
    numspace = findstr(help_data{1},'description')
    
    HelpText = help_data{1};
    
    newText = {};
    index = 0;
    for line = strsplit(HelpText,newline)
        index = index + 1;
        newText{index} = line{:}(numspace:end);
    end
    
    HelpText = join(newText,newline);
    
    HelpText= HelpText{:};
    HelpText = strtrim(HelpText);
end
