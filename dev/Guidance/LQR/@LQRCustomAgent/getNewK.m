% Update K from critic
function k = getNewK(obj)
    w = getLearnableParameters(obj.Critic);
    w = w{1};
    nQ = size(obj.Q,1);
    nR = size(obj.R,1);
    n = nQ+nR;
    idx = 1;
    for r = 1:n
        for c = r:n
            Phat(r,c) = w(idx);
            idx = idx + 1;
        end
    end
    S  = 1/2*(Phat+Phat');
    Suu = S(nQ+1:end,nQ+1:end);
    Sux = S(nQ+1:end,1:nQ);
    if rank(Suu) == nR
        k = Suu\Sux;
    else
        k = obj.K;
    end
end 