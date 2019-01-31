function resume(iode)
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here
tab = '     ';

switch iode.Type
    case 'InitialCondition'
        condition = 'Y(0) = ';
    case 'FinalCondition'
        condition = 'Y(T) = ';
end

display([newline, ...
         tab,'Dynamics:',newline,newline, ...
         tab,tab,'Y''(t,Y,U) = ',char(iode.Dynamic.symbolic), ...
         newline,newline, ...
         tab,tab,'t in [0,',num2str(iode.FinalTime),']  with condition: ',condition,char(join(string(iode.Condition),' ')),newline])
         
end

