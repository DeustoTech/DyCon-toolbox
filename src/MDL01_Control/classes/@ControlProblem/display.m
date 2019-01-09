function display(iCP)
%  description: display function of ControlProblem class
%  autor: JOroya
%  MandatoryInputs:   
%    iCP: 
%        description: Control Problem Object
%        type: ControlProblem
tab = '     ';
display([newline,'  Control Problem'])
display('  ===============')

display(iCP.ode)
display(iCP.Jfun)

end

