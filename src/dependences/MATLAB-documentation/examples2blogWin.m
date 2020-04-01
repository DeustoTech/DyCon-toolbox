function examples2blogWin(WP,number,varargin)
     p = inputParser;
     
     addRequired(p,'WP')
     addRequired(p,'number')
     addOptional(p,'user','Jesus')
     
     parse(p,WP,number,varargin{:})
    
     user = p.Results.user;
     
     switch user
         case  'Jesus'
            path_source='C:\Users\Jesus\Dropbox\Dycon-Project\source_code';
            path_documentation='C:\Users\Jesus\Dropbox\Dycon-Project\source_code_web';      
     end

    a = dir(['tutorials/',WP,'*/',number,'*/*.m']);
    path = a.folder;
    name = a.name;
    
    fileID = fopen([path,'\',name],'r');
    A = fscanf(fileID,'%c');
    
    A = replace(A,'$$','dollars-dollars');
    A = replace(A,'$','dollars');
    
    FileOut = fopen([path,'\',name(1:(end-2)),'-md.m'],'w');
    fwrite(FileOut,A)
    fclose(FileOut)
    %%
    % remove $$,
    publishreadme([name(1:(end-2)),'-md'],path,false)

    output_dir = [path_documentation,'\_posts\tutorials\',WP];
    system(['powershell mkdir -p ',output_dir]);
    
    %% MD file
    mdfile = [path,'\',name(1:(end-2)),'-md.md'];
    MDfile = fopen(mdfile,'r');
    B = fscanf(MDfile,'%c');
    fclose(MDfile);
    B = replace(B,'dollars-dollars','$$');
    B = replace(B,'dollars','$');
    B = replace(B,'&lt;','<');
    B = replace(B,'&gt;','>');
    B = replace(B,['# .\imgs-matlab\',name(1:(end-2)),'-md'],'');
    
    
   B = replace(B,'](extra-data',['](..\..\assets\imgs\',WP,'\',number]);
   B = replace(B,'](.\imgs-matlab',['](..\..\assets\imgs\',WP,'\',number]);

   
   metadatafile = fopen([path,'\metadata.txt']);
   metadata = fscanf(metadatafile,'%c');
   fclose(metadatafile);

   Bsplit = strsplit(metadata,'\n');
   index_logical = arrayfun(@(row) contains(row,'date:'),Bsplit);
    
   date = Bsplit{index_logical};
   date = replace(date,'date:','');
   date = strtrim(date);
    
    %%
   output_file = [output_dir,'\',date,'-',number,'-T.md'];

    FINALFILE = fopen([output_file],'w');
    
    fprintf(FINALFILE,'---\n')
    fprintf(FINALFILE,['categories: [Tutorials ,',WP,']\n'])
    fprintf(FINALFILE,'layout: post\n')
    fprintf(FINALFILE,['WP: ',WP,'\n'])
    fprintf(FINALFILE,[metadata,'\n'])
    fprintf(FINALFILE,'---\n')
    fwrite(FINALFILE,B)
    fclose(FINALFILE)
    
    pause(1.0)
    system(['powershell rm ',path,'\*-md.*'])
    %% Imgs
    path_imgs = [path_documentation,'\assets\imgs\',WP,'\',number];
    system(['mkdir ',path_imgs]);
    system(['copy ',path,'\imgs-matlab\* ',path_imgs,'\']);
    %% Extras 
    system(['copy ',path,'\extra-data\* ',path_imgs,'\']);


 end

