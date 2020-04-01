function functions2blog(FunctionName,FolderDocumentation)
    
    path_function = which(FunctionName);


    mkdir([FolderDocumentation,'/',FunctionName])
    
    FolderDocumentation = [FolderDocumentation,'/',FunctionName];
    %% module
    module = strsplit(path_function,'/');
    module = module{end-2};
    module = strsplit(module,'_');
    module = module{1};
    %% Contructor 

    help_data = ObtainHelp(path_function);
    
    help_data = replace(help_data,'\','\\');
    %% HELP file
    help_mfile = ['help_',FunctionName];
    path_help = which(help_mfile);
    if ~isempty(path_help)
        path_help = strsplit(path_help,'/');
        path_help = path_help(1:end-1);
        path_help = join(path_help,'/');
        path_help = path_help{:};

        publishreadme(help_mfile,path_help,true);

        md = fopen([path_help,'/',help_mfile,'.md'],'r');
        mdcontent = fscanf(md,'%c');
        mdcontent = strsplit(mdcontent,[newline,newline]);
        mdcontent = mdcontent(2:end);
        mdcontent = join(mdcontent,[newline,newline]);
        mdcontent = mdcontent{:};
        fclose(md);
    end
    
    %% Load File
    outfile_path = [FolderDocumentation,'/0001-01-01-',FunctionName,'.md'];
    if exist(outfile_path,'file')
       delete(outfile_path);
    end
    
    outfile_constructor = fopen(outfile_path,'a');
    
    fprintf(outfile_constructor,'---\n');
    fprintf(outfile_constructor,['data:\n']);
     fprintf(outfile_constructor,help_data);
    fprintf(outfile_constructor,'\n');
    fprintf(outfile_constructor,['title: ',FunctionName,'\n']);
    fprintf(outfile_constructor,['categories: [documentation, ',module,']\n']);
    fprintf(outfile_constructor,'layout: function');
    fprintf(outfile_constructor,'\n');
    if ~isempty(path_help)
        fprintf(outfile_constructor,['helpfile: ',path_help,'\n']);
    end
    fprintf(outfile_constructor,'---\n');

    if ~isempty(path_help)
       fprintf(outfile_constructor,mdcontent);
    end
    fclose(outfile_constructor);
    
    
    
    
    %%

end


function HelpText = ObtainHelp(path_file)

    help_data   = help(path_file);
    help_data = strsplit(help_data,'Reference page');
    HelpText = help_data{1};
    HelpText = join(strsplit(HelpText,'\n'),newline);
    
    HelpText= HelpText{:};
end
