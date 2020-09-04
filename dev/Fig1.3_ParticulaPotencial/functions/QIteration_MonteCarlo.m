function [V,pi,Vhistory,Pihisotry] = QIteration(f_x,f_v,vl,xl,al,dt)

Rfcn = @(x,v,a) exp( -x.^2/0.1^2 - v.^2/2^2);

Na = length(al);
Nvl = length(vl);
Nxl = length(xl);
Q  = zeros(Na,Nvl,Nxl);

[xms,vms,ams] = meshgrid(xl,vl,al);
%%

[new_xms,new_vms] = rk4_step_2D(f_x,f_v,dt,xms,vms,ams);

%%

   ind_v_ms = 0*vms;
   ind_x_ms = 0*xms;
   
    for ind_x = 1:Nxl
        for ind_v = 1:Nvl
        
            for ind_a = 1:Na
            
                stn = [  new_xms(ind_v,ind_x,ind_a)     ;...
                         new_vms(ind_v,ind_x,ind_a)   ];
                     
                [~,ind_x_ms(ind_v,ind_x,ind_a)] = min(abs(stn(1)-xl));
                [~,ind_v_ms(ind_v,ind_x,ind_a)] = min(abs(stn(2)-vl));

            end
        end 
    end
    %%
MaxIter = 500;

Vhistory = zeros(Nvl,Nxl,MaxIter);
Pihisotry = zeros(Nvl,Nxl,MaxIter);

gamma = 0.5;
alpha = 0.5;
for iter = 1:MaxIter
    

    [V,pi] = max(Q);

    V = reshape(V,Nvl,Nxl);
    pi = reshape(pi,Nvl,Nxl);

   Vhistory(:,:,iter) = V;
   Pihisotry(:,:,iter) = pi;
       
   
  
    Qold = Q;
    for ind_x = 1:Nxl
        for ind_v = 1:Nvl
                ind_a = randsample(1:Na,1);
                
                ind_x_next = ind_x_ms(ind_v,ind_x,ind_a);
                ind_v_next = ind_v_ms(ind_v,ind_x,ind_a);
                %
                [Qmax,~] = max([Q(:,ind_v_next,ind_x_next)]);
                %
                Q(ind_a,ind_v,ind_x) = (1-alpha)*Q(ind_a,ind_v,ind_x) + ...
                                         alpha*(Rfcn(xl(ind_x),vl(ind_v),al(ind_a)) +gamma*Qmax);
           
        end 
    end
    
    err = norm(Q(:)-Qold(:));
    fprintf("error = "+err+"\n")
    if err < 1e-5
        break
    end
    
end

[V,pi] = max(Q);

V = reshape(V,Nvl,Nxl);
pi = reshape(pi,Nvl,Nxl);

end

