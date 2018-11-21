function function2blogWin(WP,number,name_function)
%FUNCTIONS2BLOG Summary of this function goes here
%   Detailed explanation goes here
    path_source='/Users/jesusoroya/Dropbox/Dycon-Project/source_code';
    path_documentation='/Users/jesusoroya/Dropbox/Dycon-Project/source_code_web';
    
    [rt ,result] = system(['ls ',path_source,'/tutorials/',WP,'*/',number,'*/functions/',name_function,'/',name_function,'.m']);
    if rt;error(' ');end
    
    result = strtrim(result);
    result = replace(result,' ','\ ');
    
    name = strsplit(result,'/');
    name = name{end};name = name(1:end-2);
    path_function = result(1:end-length(name)-3);
    
        
    result = help([name_function,'.m']);
    file   = fopen('help.txt','w');
    
    fwrite(file,result)
    
    output_dir = [path_documentation,'/_posts/functions'];
    
    system(['mkdir -p ',output_dir]);


     %%
    [~ ,date] = system(['cat ',path_function,'/',name_function,'.m | grep date: | sed ''s/date://g''| awk ''{$1=""}1'' ']);
    date = strtrim(date);   
    
    output_file = [output_dir,'/',date,'-',name_function,'-F.md'];

    
    system(['echo --- >',output_file]);
    system(['echo ''  layout: function'' >> ',output_file]);
    system(['echo ''  categories: Functions'' >> ',output_file]);
    system(['echo ''  title: ',name_function,''' >>',output_file]);
    system(['cat help.txt | grep -v ''======='' >> ',output_file]);
    system(['echo --- >>',output_file]);
    
    
    %%  Examples
    
    
    system(['cat ',path_function,'/','help_',name_function,'.m ', ...
                '|sed ''s/\$\$/dollardollar/g''' ...
                '>',path_function,'/help_file.m']);
    publishreadme('help_file',path_function,false)
    
    
   
    system(['echo ''<hr>'' >>',output_file ])
    system(['echo ''## Description'' >>',output_file ])

    system(['cat ',path_function,'/help_file.md |', ...
            ' sed ''s/imgs-matlab/..\/assets\/imgs\/functions\/',name_function,'/g'' ', ...
            '|sed ''s/dollardollar/\$\$/g''', ...
            '|sed ''s/\&amp;/\&/g''', ...
           '|tail -n +3', ...
            '>>',output_file]) 

        
    
    system('rm help.*')
    system(['rm ',path_function,'/help_file.*']);
    system(['rm -r',path_function,'/imgs-matlab']);

    system(['rm helps/',name_function,'-h/help_',name_function,'.md']);

    %% Copy imgs
    path_imgs = [path_documentation,'/assets/imgs/functions/',name_function];
    system(['mkdir -p ',path_imgs]);
    system(['cp ',path_function,'/imgs-matlab/* ',path_imgs,'/']);
    
    %%

end

