function Vector = SymsVector(name_cordinates,dimension,varargin)
%SYMSVECTOR 

    p = inputParser;
    addRequired(p,'name_cordinates')
    addRequired(p,'dimension')
    addOptional(p,'by','row')
    
    parse(p,name_cordinates,dimension,varargin{:})
    
    by = p.Results.by;
    
     
    cells = cellstr(strcat(repmat(name_cordinates,dimension,1),num2str((1:dimension)')));
    cells = arrayfun(@(x) replace(x,' ',''),cells);
    syms(cells)
    
    switch by
        case 'row'
            Vector = sym(zeros(dimension,1));
        case 'col'
            Vector = sym(zeros(1,dimension));
        otherwise
            error('''by'' parameter must be ''row'' or ''col''')
    end
    
    
    for i = 1:dimension
        cmd = ['Vector(i) = ',cells{i},';'];
        eval(cmd)
    end
    
end

