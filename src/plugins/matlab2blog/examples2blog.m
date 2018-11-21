function examples2blog(WP,number,varargin)
     p = inputParser;
     
     addRequired(p,'WP')
     addRequired(p,'number')
     addOptional(p,'user','Jesus')
     
     parse(p,WP,number,varargin{:})
    
     user = p.Results.user;
     
     switch user
         case  'Jesus'
            path_source='/Users/jesusoroya/Dropbox/Dycon-Project/source_code';
            path_documentation='/Users/jesusoroya/Dropbox/Dycon-Project/source_code_web';      
         case 'Dario'
             
         case 'Umberto'
            path_source='/home/umberto/Dropbox/Dycon-Project/source_code';
            path_documentation='/home/umberto/Dropbox/Dycon-Project/source_code_web'; 
            
     end


    [rt ,result] = system(['ls ',path_source,'/tutorials/',WP,'*/',number,'*/*.m']);
    if rt;error(' ');end
    
    result = strtrim(result);
    result = replace(result,' ','\ ');
    
    name = strsplit(result,'/');
    name = name{end};name = name(1:end-2);
    path = result(1:end-length(name)-3);

    %%
    % remove $$,
    system(['cat ',path,'/',name,'.m |sed ''s/\$\$/dollars-dollars/g''|sed ''s/\$/dollars/g'' > ',path,'/',name,'-md.m'])
    publishreadme([name,'-md'],replace(path,'\',''),false)

    output_dir = [path_documentation,'/_posts/tutorials/',WP];
    system(['mkdir -p ',output_dir]);
    
        
    %% MD file
    mdfile = [path,'/',name,'-md.md'];
    % extract data 

    [~ ,date] = system(['cat ',path,'/metadata.txt| grep date: |sed ''s/date://g''']);
    date = strtrim(date);
        
    output_file = [output_dir,'/',date,'-',number,'-T.md'];

        
    system(['echo --- >',output_file]);
    system(['cat ',path,'/metadata.txt >> ',output_file])
    system(['echo ''date: ',date,''' >>',output_file]);
    system(['echo ''categories: [Tutorials ,',WP,']''>>',output_file]);
    system(['echo ''layout: post '' >>',output_file]);

    system(['echo ''WP: ',WP,''' >>',output_file]);
    system(['echo ''number: ',number,''' >>',output_file]);

    system(['echo --- >>',output_file]);

    cmd = ['cat ',mdfile, ...
           '|tail -n +3', ...
           '|sed ''s/dollars-dollars/\$\$/g'' ', ...
           '|sed ''s/dollars/\$/g'' ', ...
           '|sed ''s/andand/\&/g''' ...
           '|sed ''s/{{/{ {/g''' ...
           '|sed ''s/\&amp;/\&/g''' ...
           '|grep -v title:',...
           '|grep -v subtitle:',...
           '|grep -v date:',...
           '|grep -v author:',...
           '|sed ''s/&lt;/</g ''',...
           '|sed ''s/](extra-data/](..\/..\/assets\/imgs\/',WP,'\/',number,'/g''', ...
           '|sed ''s/imgs-matlab/..\/..\/assets\/imgs\/',WP,'\/',number,'/g''', ...
           '>> ',output_file];
    system(cmd);

    %% Imgs
    path_imgs = [path_documentation,'/assets/imgs/',WP,'/',number];
    system(['mkdir -p ',path_imgs]);
    system(['cp ',path,'/imgs-matlab/* ',path_imgs,'/']);
    %% Extras 
    system(['cp ',path,'/extra-data/* ',path_imgs,'/']);

    %%
    
    system(['rm ',path,'/*-md.*']);
    system(['rm -r',path,'/imgs-matlab']);

 end

