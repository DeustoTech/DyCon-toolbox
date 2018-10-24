Nsysnew =[];Nsysstr="";
for i =1:length(Nsys)
    chr = char(Nsys(i));
    str = string(chr);
    Nsysstr = strcat(Nsysstr,";",str);
end
Nsysstr = extractAfter(Nsysstr,1);
for i = 1:length(Nsys)
Nsysstr = replace(Nsysstr,strcat("x",num2str(i)),strcat("x(",num2str(i),")"));
end
% Physical parameters
m = 0.3;% [kg];
M = 0.8;% [kg];
l = 0.25;% [m];
g = 9.8;% [m/s^2];

eqeval = strcat("Nsys_eq = @(x,u)", "[",Nsysstr,"]")
eval(eqeval)

