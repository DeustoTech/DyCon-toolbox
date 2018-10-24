
clearvars -except donnees maillage opt_sel nu_sel sec_membre...
     yd calcul_norme_Eh produitscalaire_Eh init_matrices grad_conj ...
     solution_adjoint solution_forward separation
clc

%%% Selection of parameter
selection=[5*pi^2/2];
fprintf('Your selection: %f \n\n', selection)

%%% Computing the residual for the given parameter
matrices = init_matrices(selection,maillage);

tic;
switch donnees.surrogate
    case 'regular'
        error('not implemented yet')
    case 'vectorial'
        sel_p=opt_sel(1:maillage.N^2,:);
        sel_y=opt_sel(maillage.N^2+1:end,:);
        online_free=[ zeros(maillage.N^2,1) ; donnees.beta*yd ];
end

for i=1:size(opt_sel,2)    
    res_p0(:,i)=[matrices.B*sel_p(:,i);matrices.A*sel_p(:,i)];   
    res_0y(:,i)=[matrices.A*sel_y(:,i);-donnees.beta*sel_y(:,i)];                     
end
    
online_proj=projection(online_free,[res_p0 res_0y]);

online_alpha=[res_p0 res_0y]\online_proj;

online_control=zeros(maillage.N^2,1);
toc;

for i=1:size(opt_sel,2)
    online_control=online_control+online_alpha(i)*sel_p(:,i);
end

u_gr_on=matrices.B*online_control;
soly_gr_on=solution_forward(u_gr_on,donnees,matrices);

tic;
c_3=datestr(now);
%%% Online real control
%%%
[mu_r,it]=grad_conj(maillage,donnees,matrices,sec_membre,...
                         donnees.tolerance,'oui',0*sec_membre);
    
    solp_real_on=solution_adjoint(mu_r,donnees,matrices);
    u_ron=matrices.B*solp_real_on;
    soly_real_on=solution_forward(u_ron,donnees,matrices);
toc;
c_4=datestr(now);
    
    fprintf(separation);
    
    fprintf('Coût du controle : %4.2e\n',...
            calcul_norme_Eh(maillage,u_ron,0));
    
    F=1/2*calcul_norme_Eh(maillage,u_ron,0)^2+...
      donnees.beta/2*calcul_norme_Eh(maillage,soly_real_on-yd,0)^2;
    fprintf('F(v_opt)= %g \n',F);
    
    J=1/2*calcul_norme_Eh(maillage,u_ron,0)^2+...
      1/(2*donnees.beta)*calcul_norme_Eh(maillage,mu_r,0)^2-...
      produitscalaire_Eh(maillage,mu_r,yd,0);
    fprintf('J(mu_opt)= %g \n',J);
    
    fprintf('F_(v_opt)~J(mu_opt)= %g \n',abs(F+J)/(abs(F)+abs(J)));
    
    fprintf('Norm |u_real-u_online|: %e\n',calcul_norme_Eh(maillage,u_ron-u_gr_on,0))

figure(1)
surf(maillage.xi,maillage.yj,reshape(u_gr_on,maillage.N,maillage.N))
figure(2)
surf(maillage.xi,maillage.yj,reshape( soly_real_on,maillage.N,maillage.N))
% surf(maillage.xi,maillage.yj,reshape( yd,maillage.N,maillage.N))
% plot3(maillage.xi(:,1),1/2*ones(50,1),donnees.y_d(maillage.xi(:,1),ones(maillage.N,1)))
figure(3)
surf(maillage.xi,maillage.yj,reshape( yd,maillage.N,maillage.N))

calcul_norme_Eh(maillage,soly_real_on-soly_gr_on,0);



%****************************
%Write on the .org file
%v 0.1
%****************************

if donnees.atracer 
    
u_gr_plot=reshape(u_gr_on,maillage.N,maillage.N)';
y_gr_plot=reshape(soly_gr_on,maillage.N,maillage.N)';
    
disp('saving data...')

dt = datestr(now,'dd-mm-yyyy');
ht = datestr(now,'HH');
mt = datestr(now,'MM');
name_result_control = strcat('results_greedy/','result_control_',...
                  dt,'_',ht,'h',mt,'.org');

name_result_state = strcat('results_greedy/','result_state_',...
                  dt,'_',ht,'h',mt,'.org');
              
             
file_result_temp_control=name_result_control;
file_result_temp_state=name_result_state;

outs_file_temp=fopen(file_result_temp_control,'w');
outs_file_state=fopen(file_result_temp_state,'w');

%Control
fprintf(outs_file_temp,strcat('#',name_result_control,'\t - \t',donnees.nom,'\n'));
fprintf(outs_file_temp,...
        '%s N=%d, \\beta=%.2e, eps=%4.4f, \\nu=[%.1f,%.1f], k-sample=%i \n',...
        '#Sim. param.:',maillage.N,donnees.beta,donnees.eps,...
         donnees.nu_min,donnees.nu_max,donnees.k);
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
        '%s N=%d, \\beta=%.2e, eps=%4.4f, \\nu=[%.1f,%.1f], k-sample=%i \n',...
        '#Sim. param.:',maillage.N,donnees.beta,donnees.eps,...
         donnees.nu_min,donnees.nu_max,donnees.k);
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
        [0;maillage.xi(:,i);1] [0;u_gr_plot(:,i);0]].');
    fprintf(outs_file_temp,'\n');
    
    %state
    fprintf(outs_file_state, '%4.4f %4.4f %4.4f \n',...
    [[maillage.yj(1,i);maillage.yj(:,i);maillage.yj(1,i)]...
        [0;maillage.xi(:,i);1] [0;y_gr_plot(:,i);0]].');
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
    
%**para debug
error('toto')

    function [y]=projection(v,B)
    g=orth(B);
    [m,n]=size(g);
    y=zeros(m,1);
    for j=1:1:n
        y=y+dot(v,g(:,j))*g(:,j);
    end
 end
