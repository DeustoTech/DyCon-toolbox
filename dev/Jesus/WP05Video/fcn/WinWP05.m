function result = WinWP05(s,pos,width)
%BWP05 Summary of this function goes here
%   Detailed explanation goes here
pm = ones(size(s));
result   =   thetaWP05(s+0.5*width-pm*pos) - thetaWP05(s-0.5*width-pm*pos);

end

