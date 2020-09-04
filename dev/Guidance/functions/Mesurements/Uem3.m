function [result] = Uem3(st,Ut,Ne,Nd)

ue = Ue(st,Ne);
ud = Ud(st,Nd);


SquareDist = NormArray(ue - Ut.r);
ind = zeros(1,Nd);
for i = 1:Nd
    UdDist = NormArray(ud(:,i) - ue);
    [~ ,ind(i)] = max(-0.3*UdDist  + 0.7*SquareDist);
end
result = ue(:,ind);


end

