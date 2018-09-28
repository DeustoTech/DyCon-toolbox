function functions2blog(name_function)
%FUNCTIONS2BLOG Summary of this function goes here
%   Detailed explanation goes here
    path_source='/Users/jesusoroya/Documents/GitHub/dycon-platform';
    path_documentation='/Users/jesusoroya/Documents/GitHub/dycon-platform-documentation';
    
    path_function = [path_source,'/source/',name_function,'.m'];
    
    result = help(name_function);
    file   = fopen('help.txt','w');
    
    fwrite(file,result)
    
    output_dir = [path_documentation,'/_posts/functions'];
    
    system(['mkdir -p ',output_dir]);


     %%
    [~ ,date] = system(['cat ',path_function,' | grep date: | sed ''s/date://g''| awk ''{$1=""}1'' ']);
    date = strtrim(date);   
    
    output_file = [output_dir,'/',date,'-',name_function,'-F.md'];

    
    system(['echo --- >',output_file]);
    system(['echo ''  layout: function'' >> ',output_file]);
    system(['echo ''  categories: functions'' >> ',output_file]);
    system(['echo ''  title: ',name_function,''' >>',output_file]);
    system(['cat ''help.txt'' | grep -v ''======='' >> ',output_file]);
    system(['echo --- >>',output_file]);
    
    

    [~ ,author] = system(['cat ',path_function,' | grep author: | sed ''s/author://g''| awk ''{$1=""}1'' ']);
    author = strtrim(author);
 
    [~ ,short_des] = system(['cat ',path_function,' | grep short_description: | sed ''s/short_description://g''| awk ''{$1=""}1'' ']);
    short_des = strtrim(short_des);

    %%  Examples
    
    path_help = [path_source,'/helps/',name_function,'-h'];
    
    publishreadme(['help_',name_function],path_help,false)
    
    system(['cat helps/',name_function,'-h/help_',name_function,'.md |', ...
            ' sed ''s/imgs-matlab/..\/assets\/imgs\/functions/g'' ', ...
           '|tail -n +3', ...
            '>>',output_file]) 

    
    system('rm help.*')
    system(['rm helps/',name_function,'-h/help_',name_function,'.html'])
    system(['rm helps/',name_function,'-h/help_',name_function,'.md'])

    %% Copy imgs
    path_imgs = [path_documentation,'/assets/imgs/functions'];
    system(['mkdir -p ',path_imgs]);
    system(['cp ',path_source,'/helps/',name_function,'-h/imgs-matlab/* ',path_imgs,'/']);
    
    %%
    system(['rm -r ',path_source,'/helps/',name_function,'-h/imgs-matlab'])

end

