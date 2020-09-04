function [ind_d] = state2action(obj,State0,eps)

    r   = norm(Ut.r-Uem(State0,Ne));
    [~,indx_r] = min(abs(r-RF.rline));
    %
    var = sqrt(norm(CoUe(State0,Ne)));
    [~,indx_v] = min(abs(var-RF.vline));
    
    if rand > eps
        Qvalues = RF.Qtable(indx_r,indx_v,:); 
        [~,ind_d] = max(Qvalues);
        
        indexs = 1:RF.Nd;
        ind_b =indexs(Qvalues(ind_d) == Qvalues);
        if length(ind_b) > 1
            ind_d = randsample(ind_b,1,true);
        end
    else
        ind_d = randsample(1:RF.Nd,1,true);
    end
    
end

