function resume(iode)
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here
tab = '     ';


if ~isempty(iode.Y)
    msg_solution = [newline,tab,'This ode the solution of this ode is:',newline,newline, ...
                    tab,tab,'Y(T) = ',char(join(string(iode.Yend))),newline];
else
    msg_solution = '';
end
    
    
display([newline, ...
         tab,'Dynamics:',newline,newline, ...
         tab,tab,'Y''(t,Y,U) = ',char(iode.symF), ...
         newline,newline, ...
         tab,'In interval of time: [0,',num2str(iode.T),']',newline,newline, ...
         tab,tab,'Y(0) = ',char(join(string(iode.Y0),' ')),newline, ...
         msg_solution])
         
end

