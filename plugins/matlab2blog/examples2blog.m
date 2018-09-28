function examples2blog(WP,number)

    path_source='/Users/jesusoroya/Documents/GitHub/dycon-platform';
    path_documentation='/Users/jesusoroya/Documents/GitHub/dycon-platform-documentation';

    [~ ,result] = system(['ls ',path_source,'/examples/',WP,'*/',number,'*/*.m']);
    result = strtrim(result);
    
    name = strsplit(result,'/');
    name = name{end};name = name(1:end-2);
    path = result(1:end-length(name)-3);

    %%
    % remove $$,
    system(['cat ',path,'/',name,'.m |sed ''s/\$\$/dollars-dollars/g''|sed ''s/\$/dollars/g'' > ',path,'/',name,'-md.m'])
    publishreadme([name,'-md'],path,false)

    output_dir = [path_documentation,'/_posts/examples/',WP];
    system(['mkdir -p ',output_dir]);
    
        
    %% MD file
    mdfile = [path,'/',name,'-md.md'];
    % extract data 
    [~ ,title] = system(['cat ',mdfile,' | grep title: |sed ''s/title://g''| awk ''{$1=""}1'' ']);
    title = strtrim(title);

    [~ ,date] = system(['cat ',mdfile,' | grep date: |sed ''s/date://g''| awk ''{$1=""}1'' ']);
    date = strtrim(date);

    [~ ,author] = system(['cat ',mdfile,' | grep author: | sed ''s/author://g''| awk ''{$1=""}1'' ']);
    author = strtrim(author);
    
    
    output_file = [output_dir,'/',date,'-',number,'-T.md'];

        
    system(['echo --- >',output_file]);
    system(['echo title: ',title,'>>',output_file]);
    system(['echo date: ',date,'>>',output_file]);
    system(['echo author: ',author,'>>',output_file]);
    system(['echo categories: [examples ,',WP,']>>',output_file]);

    system(['echo WP: ',WP,' >>',output_file]);

    system(['echo --- >>',output_file]);

    cmd = ['cat ',mdfile, ...
           '|tail -n +3', ...
           '|sed ''s/dollars-dollars/\$\$/g'' ', ...
           '|sed ''s/dollars/\$/g'' ', ...
           '|grep -v title:',...
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
 end

