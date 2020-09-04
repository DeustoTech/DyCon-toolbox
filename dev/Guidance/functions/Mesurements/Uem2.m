function [result] = Uem2(State,Ne,Nd)

ue = Ue(State,Ne);
ud = Ud(State,Nd);


SquareDist = NormArray(ue - Uem(State,Ne));
ind = zeros(1,Nd);
for i = 1:Nd
    UdDist = NormArray(ud(:,i) - ue);
    [~ ,ind(i)] = max(-0.3*UdDist  + 0.7*SquareDist);
end
result = ue(:,ind);


end

