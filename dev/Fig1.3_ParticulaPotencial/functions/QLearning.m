function [pi,W,Q] = QLearning(f,vl,xl,al,dt,Nt)

Rfcn = @(x,v,a) exp(-a.^2 -x.^2/0.5^2 - v.^2/0.5^2);

Na  = length(al);
Nvl = length(vl);
Nxl = length(xl);
%
MaxEpochs = 5000;
%
gamma = 0.7;
indexs = 1:Na;
alpha = 1;
%%
[vms2,ams2,xms2] = meshgrid(vl,al,xl);
Q = 10*Rfcn(xms2,vms2,ams2);
%%
  
[W,pi] = max(Q);
W  = reshape(W,Nvl,Nxl);
pi = reshape(pi,Nvl,Nxl);

epsilon0 = 0.99;


for iepoch = 1:MaxEpochs
    
    epsilon = epsilon0/iepoch^(1/4);
    stc = [normrnd(0.0 , 4  ,1,1) , ...
           normrnd(0.0 , 4  ,1,1)]';
    for it = 1:Nt        
        
        [~,ind_x] = min(abs(stc(1)-xl));
        [~,ind_v] = min(abs(stc(2)-vl));
        
        % choose action
        if rand < epsilon 
            ind_a = randsample(indexs,1);
        else
           Qvalue = Q(:,ind_v,ind_x);
           [Qmax,ind_a] =  max(Qvalue);
           if length(Qmax)>1
                ind_a = randsample(indexs(Qvalue==Qmax),1);
           end
        end           

        % update dynamic
        stn = rk4_step(@(t,s) f(s,al(ind_a)),0,dt,stc);
        %%
        if stn(1) < xl(1) || stn(1) > xl(end) || stn(2) < vl(1) || stn(2) > vl(end)
            break 
        end  
        %%
        % take indexs
        [~,ind_x_next] = min(abs(stn(1)-xl));
        [~,ind_v_next] = min(abs(stn(2)-vl));
        %
        [Qmax,~] = max(Q(:,ind_v_next,ind_x_next));
        %
        Q(ind_a,ind_v,ind_x) = (1-alpha)*Q(ind_a,ind_v,ind_x) + ...
                                 alpha*(Rfcn(xl(ind_x),vl(ind_v),al(ind_a)) +gamma*Qmax);
        stc = stn;
    end
    if mod(iepoch,100) == 0
        fprintf("  epoch: "+iepoch+"\n")
    end
end


[W,pi] = max(Q);

W = reshape(W,Nvl,Nxl);
pi = reshape(pi,Nvl,Nxl);

end

