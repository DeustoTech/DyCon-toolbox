
function result = evaluatePolicy(st,xl,vl,al,Pi)
    [~,ind_x] = min(abs(st(1)-xl));
    [~,ind_v] = min(abs(st(2)-vl));
    result = al(Pi(ind_v,ind_x));
end