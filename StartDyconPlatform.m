function StartDyconPlatform()
%STARTDYCONPLATFORM - Agrea las carpetas necesarias para ejecutar todos los tutoriales
file        = 'StartDyconPlatform.m';
pathfile    =  replace(which(file),file,''); 

cd(pathfile)
%% Dependences 

%% CasADi

if ismac
    unzip('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-osx-matlabR2015a-v3.5.1.tar.gz')
elseif ispc
    unzip('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-windows-matlabR2016a-v3.5.1.zip')
elseif isunix
    unzip('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-linux-matlabR2014b-v3.5.1.tar.gz')
end

addpath(genpath(pathfile))

end

