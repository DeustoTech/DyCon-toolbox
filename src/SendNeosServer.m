function outputpath = SendNeosServer(file)


        mainpath        = 'StartDyconPlatform.m'; 
        mainpath    =  replace(which(mainpath),mainpath,''); 
        %% 
        fullfilepath = which(file);
        if isempty(fullfilepath)
           error('File doesn''t exist') 
        end
        cellpath = strsplit(fullfilepath,filesep);
        ineosjob.file = cellpath{end};
        %replace(ineosjob.file,'.','')
        ineosjob.path = fullfile(cellpath{1:end-1});
        ineosjob.path = [filesep,ineosjob.path];
        %%
        rd = num2str(randi(1e6),'%.6d');
        time = clock;
        time = replace(join(strsplit(num2str(time(4:6)),' '),'-'),'.','');
        time = time{:};
        rd = [date,'-',time,'-',rd,'-',ineosjob.file];
        outputfolder = fullfile(mainpath,'tmp','AMPL-executions',rd);
        mkdir(outputfolder);

        outputpath = fullfile(outputfolder,[ineosjob.file,'.out']);
        %% copy inputs
        inputfile = fullfile(ineosjob.path,ineosjob.file);
        copyfile(inputfile, fullfile(outputfolder,ineosjob.file));
        %%

        data         = yaml.ReadYaml(fullfile(mainpath,'UserConfig','NeosUser.yaml'));
        if isempty(data.user) ||  isempty(data.password) ||  isempty(data.email)
           error(['Please Configure your file',newline,newline, ...
                 '  >>>>>>     ',which('NeosUser.yaml'),'   <<<<<<<<',newline,newline, ...
                 'Set your user, email and password of Neos Server.']) 
        end
        pythonstript =  fullfile(mainpath,'src','plugins','PythonClient-master','NeosClientMATLAB.py');

        xmltemplate  =  fullfile(mainpath,'src','Neos','@NeosJob','template.xml');
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
        xmlpath = fullfile(outputfolder,[ineosjob.file,'.xml']);
        if exist(xmlpath,'file')
            delete(xmlpath)
        end
        pause(0.5)
        newxmlfile = fopen(xmlpath,'w');
        fwrite(newxmlfile,xmldata);
        fclose(newxmlfile);
        %%
        system(['python ',pythonstript,' ',xmlpath,' > ',outputpath,' '  ]);
        
        display(['Output in: ',outputpath,newline])
            
end

