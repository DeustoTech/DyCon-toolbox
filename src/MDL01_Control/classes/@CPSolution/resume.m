function resume(obj)
   tab='    ';
   display([newline, ...
            tab,'Solve with presicion: ',newline,newline, ...
            tab,tab,'We obtain: J(u) = ',num2str(obj.JOptimal,'%E'),newline,newline, ...
            tab,tab,'mean(||dJ_i||) = ',num2str(obj.precision,'%E'),newline,newline, ...
            tab,'With ',num2str(obj.iter),' iterations, ', ...
            tab,'In ',num2str(obj.time),' seconds',newline])
end
