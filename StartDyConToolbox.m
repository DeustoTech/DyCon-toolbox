function StartDyConToolbox()
%STARTDYCONPLATFORM - Agrea las carpetas necesarias para ejecutar todos los tutoriales
file        = 'StartDyConToolbox.m';
pathfile    =  replace(which(file),file,''); 

cd(pathfile)
addpath(genpath(pathfile))

%% Dependences 

%% CasADi


try
    casadi.SX.sym('s');
catch
    disp('CasADi will be download ...')
    casADi_folder = fullfile(pathfile,'src','dependences','CasADi');
    if ~exist(casADi_folder,'dir')
        mkdir(casADi_folder)
    end
    if ismac
        untar('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-osx-matlabR2015a-v3.5.1.tar.gz',casADi_folder)
    elseif ispc
        unzip('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-windows-matlabR2016a-v3.5.1.zip',casADi_folder)
    elseif isunix
        untar('https://github.com/casadi/casadi/releases/download/3.5.1/casadi-linux-matlabR2014b-v3.5.1.tar.gz',casADi_folder)
    end
    addpath(genpath(pathfile))

end

end

