function fcnVecotrial = VectorialForm(fcn,simbols,vectorial)

    xstr =strjoin(arrayfun(@char, simbols, 'uniform', 0),'), ');
    cmd = ['@',vectorial,' fcn(',xstr,'));'];
    cmd = replace(cmd,'y','Y(');
    cmd = replace(cmd,'u','U(');
    cmd = replace(cmd,'p','P(');

    cmd = replace(cmd,'t)','t');
    
    eval(['fcnVecotrial = ',cmd])
end
