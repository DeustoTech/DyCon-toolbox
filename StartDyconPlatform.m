function StartDyconPlatform()
%STARTDYCONPLATFORM - Agrea las carpetas necesarias para ejecutar todos los tutoriales
file        = 'StartDyconPlatform.m';
pathfile    =  replace(which(file),file,''); 
addpath(genpath(pathfile))
%% Dependences

namedir = fullfile(pathfile,'src','plugins','PythonClient-master');
if ~exist(namedir,'dir')
    unzip('https://github.com/NEOS-Server/PythonClient/archive/master.zip')
    while ~exist([pathfile,'PythonClient-master'],'dir')
       pause(1) 
    end
    movefile(fullfile(pathfile,'PythonClient-master') , ...
         fullfile(pathfile,'src','plugins'));
end
%%

namedir = fullfile(pathfile,'src','plugins','yamlmatlab-master');
if ~exist(namedir,'dir')
    unzip('https://github.com/ewiger/yamlmatlab/archive/master.zip')
    while ~exist([pathfile,'yamlmatlab-master'],'dir')
       pause(1) 
    end
%     rmdir(namedir,'s')
    movefile(fullfile(pathfile,'yamlmatlab-master') , ...
             fullfile(pathfile,'src','plugins'));
     pause(1)
     addpath(namedir)
end
%%
% set password 
% set user
data        = yaml.ReadYaml(fullfile(pathfile,'UserConfig','NeosUser.yaml'));

file = fopen(fullfile(pathfile,'src','plugins','PythonClient-master','NeosClient.py'));
file_data = fscanf(file,'%c');
file_data = replace(file_data,'os.environ.get("NEOS_USERNAME", None)',['"',data.user,'"']);
file_data = replace(file_data,'os.environ.get("NEOS_PASSWORD", None)',['"',data.password,'"']);
fclose(file);

OUTfile = fopen(fullfile(pathfile,'src','plugins','PythonClient-master','NeosClientMATLAB.py'),'w');
fwrite(OUTfile,file_data);
fclose(OUTfile);



%%

addpath(genpath(pathfile))

end

