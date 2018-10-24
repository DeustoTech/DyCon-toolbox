
function plots_evolution(shots,discr,maillage,donnees,u_gr_on,soly_gr_on)

dt=donnees.T/discr.Mtemps;

for i = 1:size(shots,2)
    
    u_plot=reshape(u_gr_on(:,shots(i)),maillage.N,maillage.N)';
    yplot=reshape(soly_gr_on(:,shots(i)),maillage.N,maillage.N)';
    
    disp('saving data...')
    time=dt*(shots(i)-1);
    
    name_result_control = strcat('results_greedy/','evolution_control_',...
        string(time),'.org');
    
    name_result_state = strcat('results_greedy/','evolution_state_',...
        string(time),'.org');
    
    
    file_result_temp_control=name_result_control;
    file_result_temp_state=name_result_state;
    
    outs_file_temp=fopen(file_result_temp_control,'w');
    outs_file_state=fopen(file_result_temp_state,'w');
    
    %Control
    fprintf(outs_file_temp,strcat('#',name_result_control,'\t - \t',donnees.nom,'\n'));
    fprintf(outs_file_temp,...
        '%s N=%d, \\beta=%.2e',...
        '#Sim. param.:',maillage.N,donnees.beta);
    fprintf(outs_file_temp,'%s %s \n','#Diffusion coeff. a(x):',...
        func2str(donnees.coeff_diffusion));
    fprintf(outs_file_temp,'%s %s \n','#Control operator:',...
        func2str(donnees.mat_B));
    fprintf(outs_file_temp,'%s %s \n','#Target function y_d:',...
        func2str(donnees.y_d));
    fprintf(outs_file_temp,'%s \n','#Control:');
    
    %Estado
    fprintf(outs_file_state,strcat('#',name_result_state,'\t - \t',donnees.nom,'\n'));
    fprintf(outs_file_state,...
        '%s N=%d, \\beta=%.2e ',...
        '#Sim. param.:',maillage.N,donnees.beta);
    fprintf(outs_file_state,'%s %s \n','#Diffusion coeff. a(x):',...
        func2str(donnees.coeff_diffusion));
    fprintf(outs_file_state,'%s %s \n','#Control operator:',...
        func2str(donnees.mat_B));
    fprintf(outs_file_state,'%s %s \n','#Target function y_d:',...
        func2str(donnees.y_d));
    fprintf(outs_file_state,'%s \n','#Estado:');
    
    %%%left boundary data for control and state
    fprintf(outs_file_temp,'%4.4f %4.4f %4.4f \n',...
        [zeros(maillage.N+2,1) [0;maillage.xi(:,1);1] zeros(maillage.N+2,1)].');
    fprintf(outs_file_temp,'\n');
    %
    fprintf(outs_file_state,'%4.4f %4.4f %4.4f \n',...
        [zeros(maillage.N+2,1) [0;maillage.xi(:,1);1] zeros(maillage.N+2,1)].');
    fprintf(outs_file_state,'\n');
    
    %interior points
    for i=1:maillage.N
        %control
        fprintf(outs_file_temp, '%4.4f %4.4f %4.4f \n',...
            [[maillage.yj(1,i);maillage.yj(:,i);maillage.yj(1,i)]...
            [0;maillage.xi(:,i);1] [0;u_plot(:,i);0]].');
        fprintf(outs_file_temp,'\n');
        
        %state
        fprintf(outs_file_state, '%4.4f %4.4f %4.4f \n',...
            [[maillage.yj(1,i);maillage.yj(:,i);maillage.yj(1,i)]...
            [0;maillage.xi(:,i);1] [0;yplot(:,i);0]].');
        fprintf(outs_file_state,'\n');
    end
    
    %right boundary data for control and state
    fprintf(outs_file_temp,'%4.4f %4.4f %4.4f \n',...
        [ones(maillage.N+2,1) [0;maillage.xi(:,1);1] zeros(maillage.N+2,1)].');
    fprintf(outs_file_state,'%4.4f %4.4f %4.4f \n',...
        [ones(maillage.N+2,1) [0;maillage.xi(:,1);1] zeros(maillage.N+2,1)].');
    
    ST=fclose(outs_file_temp);
    ST_state=fclose(outs_file_state);  
end                 
end