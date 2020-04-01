function actions = orderpartition(Nq,Ne)
% Nq number of queues 
% Ne number of elements
% a_t \in N^{Nq} and sum(a_t) = Ne

if Nq > Ne
    
    actions = nchoosek(1:Nq,Ne);
end

