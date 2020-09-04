function SetDefaultGradientOptions(p)
%SETDEFAULTGRADIENTOPTIONS Summary of this function goes here
%   Detailed explanation goes here
    addRequired(p,'iocp')
    addRequired(p,'ControlGuess')

    addOptional(p,'EachIter',5)
    addOptional(p,'MinLengthStep',1e-8)
    addOptional(p,'MaxIter',100)
    addOptional(p,'tol',1e-2)
end

