function result=NeosLoadData(outfile)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here
    
    cadena = '# Variable';
    
    f = fopen(outfile,'r');
    content = fscanf(f,'%c');
    fclose(f);
    
    content = strsplit(content,'EndAMPLExecution');
    content = content{1};
    content = strsplit(content,'Variable');
    
    if length(content) == 1
       error('Need a key word: # Variable')
    end
    content = content(2:end);
    
    for icontent = content
       if isempty(replace(icontent{:},' ',''))

            continue
       end
       data = strsplit(icontent{:},newline);
       
       metadata = strsplit(data{1},'-');
       namevar  = metadata{2};
       metadata = metadata(3:end);
       metadata = arrayfun(@(idata) str2num(idata{:}),metadata);
       metadata = num2cell(metadata);
       
       data = data(2:end);
       if isempty(str2num(data{end}))
          data = data(1:end-1); 
       end
       data = arrayfun(@(idata) str2num(idata{:}),data);
       
       metadata = metadata(end:-1:1);
       if length(metadata) == 1
            data = reshape(data,metadata{:},1);
       else
            data = reshape(data,metadata{:});
       end
       result.(strtrim(namevar)) = data;
    end
    
    
end

