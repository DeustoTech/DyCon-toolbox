function StartDyconPlatform()
%STARTDYCONPLATFORM - Agrea las carpetas necesarias para ejecutar todos los tutoriales
file        = 'StartDyconPlatform.m';
pathfile    =  replace(which(file),file,'');
addpath(genpath(pathfile))
end

