function matlabclass2blog(ClassName,FolderDocumentation)
    
    data_class = what(ClassName);
    path_class = data_class.path;

    mfiles = data_class.m;

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
    help_data = replace(help_data,newline,' ');
    metadata = metaclass(eval([ClassName,'.empty']));    
    
    %% Properties 
    sp = '   ';
    listofproperties = ['properties:',newline];
    for ipl = metadata.PropertyList'
        listofproperties = [listofproperties,sp,ipl.Name,': ',newline];
        
        help_property = ObtainHelp([ClassName,'.',ipl.Name]);
        help_property = strsplit(help_property,newline);
        if length(help_property) ~= 3
           continue 
        end
        for index = 1:length(help_property)
            help_property{index} = [sp,sp,help_property{index}];
        end
        help_property = join(help_property,newline);
        help_property = help_property{:};
        
        listofproperties = [listofproperties,help_property,newline];
        
        if ipl.HasDefault
           text_default = evalc('ipl.DefaultValue');
           text_default = strsplit(strtrim(text_default),newline);
           text_default = strtrim(text_default{end});
           
           listofproperties = [listofproperties,sp,sp,'default: ',text_default,newline];
        end
    end    
    listofproperties = replace(listofproperties,'%',' ');
    
    %% methods 
    listofmethods = ['methods:',newline];
    for imtd = metadata.MethodList'
       if strcmp(imtd.DefiningClass.Name,ClassName) && ~strcmp(imtd.Name,'empty')
           listofmethods = [listofmethods,sp,imtd.Name,':',newline];
           help_mtd = help([ClassName,'/',imtd.Name]);
           help_mtd = strsplit(help_mtd,newline);
           for index_hm = 1:length(help_mtd)
               help_mtd{index_hm} = [sp,sp,help_mtd{index_hm}];
           end
          help_mtd = join(help_mtd,newline);
          help_mtd = help_mtd{:};
          listofmethods = strtrim([listofmethods,help_mtd]);
          listofmethods = [listofmethods,newline];
       end
    end
 
    %% HELP file
    help_mfile = ['help_',ClassName];
    publishreadme(help_mfile,data_class(2).path,true)
    
    md = fopen([data_class(2).path,'/',help_mfile,'.md'],'r');
    mdcontent = fscanf(md,'%c');
    mdcontent = strsplit(mdcontent,[newline,newline]);
    mdcontent = mdcontent(2:end);
    mdcontent = join(mdcontent,[newline,newline]);
    mdcontent = mdcontent{:};
    
    fclose(md)
    
    %% Load File
    outfile_path = [FolderDocumentation,'/0001-01-01-',ClassName,'.md'];
    if exist(outfile_path,'file')
       delete(outfile_path);
    end
    
    outfile_constructor = fopen(outfile_path,'a');
    
    fprintf(outfile_constructor,'---\n');
    fprintf(outfile_constructor,['description: ',help_data]);
    fprintf(outfile_constructor,'\n');
    fprintf(outfile_constructor,['title: ',ClassName,'\n']);
    fprintf(outfile_constructor,['categories: [documentation, ',module,']\n']);
    fprintf(outfile_constructor,'layout: class\n');
    fprintf(outfile_constructor,'type: constructor\n');
    fprintf(outfile_constructor,listofproperties);
    fprintf(outfile_constructor,listofmethods);
    fprintf(outfile_constructor,'\n');
    fprintf(outfile_constructor,'---\n');
    fprintf(outfile_constructor,mdcontent);

    fclose(outfile_constructor);
    
    
    
    
    %%
    
    for imfile  = mfiles'
        if strcmp(imfile{:}(1:(end-2)),ClassName) % is the constructor
            continue
        end
        mfile_path = [path_class,'/',imfile{:}];
        help_data  = ObtainHelp(mfile_path);
    end
end


function HelpText = ObtainHelp(path_file)

    help_data   = help(path_file);
    help_data = strsplit(help_data,'Reference page');
    HelpText = strtrim(help_data{1});
    HelpText = join(strtrim(strsplit(HelpText,'\n')),newline);
    
    HelpText= HelpText{:};
end
