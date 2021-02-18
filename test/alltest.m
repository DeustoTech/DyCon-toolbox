clear 

file        = 'StartDyConToolbox.m';
pathfile    =  replace(which(file),file,''); 


rode = what(fullfile(pathfile,'test','Test-DynamicalSystems'));
rocp = what(fullfile(pathfile,'test','Test-ocp'));

%
ErrorFiles = {}; 
iter = 0;
for r = {rode,rocp}
    for ir = r{:}.m'
        try
            feval(ir{:}(1:end-2))
            fprintf(ir{:}+" : No errors.\n")
        catch 
            fprintf(ir{:}+" : ERROR!!.\n")
            iter = iter + 1;
            ErrorFiles{iter} = ir{:};
        end
    end
end
%%