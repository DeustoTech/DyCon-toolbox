classdef NeosJob < handle
    %NEOSJOB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        date
        
    end
    
    methods
        function obj = NeosJob(file)
            %NEOSJOB Construct an instance of this class
            %   Detailed explanation goes here
            mainpath        = 'StartDyconPlatform.m'; 
            mainpath    =  replace(which(mainpath),mainpath,''); 

            data         = yaml.ReadYaml(fullfile(mainpath,'UserConfig','NeosUser.yaml'));
            pythonstript =  fullfile(mainpath,'src','plugins','PythonClient-master','NeosClientMATLAB.py');
            
            xmltemplate  =  fullfile(mainpath,'src','@NeosJob','template.xml');
            xmlfile = fopen(xmltemplate);
            xmldata = fscanf(xmlfile,'%c');
            %
            xmldata = replace(xmldata,'NeosMATLABEmail',data.email);
            %
            filemodel = fopen(file);
            modeldata = fscanf(filemodel,'%c');
            fclose(filemodel);
            xmldata = replace(xmldata,'NeosMATLABModel',modeldata);
            % create a file XML
            newxmlfile = fopen([file,'.xml'],'w');
            fwrite(newxmlfile,xmldata)
            fclose(newxmlfile)
            %%
            system(['python ',pythonstript,' ',file,'.xml' ])
        end
        

    end
end

