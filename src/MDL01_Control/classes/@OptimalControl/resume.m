function resume(iCP)
% description: show the most importants parameters of the control problem
% little_description: show the most importants parameters of the control problem
% autor: JOroya
% MandatoryInputs:   
%    iCP: 
%        description: Control Problem Object
%        type: ControlProblem
tab = '     ';
display([newline,'  Control Problem'])
display('  ===============')

resume(iCP.ode)

end

