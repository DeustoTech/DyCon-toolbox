function sum = mean_null(J_executionsSG)

maxdimension = max(arrayfun(@(J) length(J{:}),J_executionsSG));
sum = zeros(1,maxdimension);
for idim = 1: maxdimension
    sum(idim) = 0;
    N   = 0;
    for iJexe = J_executionsSG
        len = length(iJexe{:});
        if len >= idim
           N = N + 1; 
           sum(idim) = sum(idim) +  iJexe{:}(idim);
        end
    end
    sum(idim) = sum(idim)/N;
end
end
