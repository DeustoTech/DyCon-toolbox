function pi = QLearning(Vpot,f,vl,xl,al,dt,Nt)

%Rfcn = @(x,v,a) 100*exp(-(x.^2 + v.^2)/1^2) + 500*exp(-x.^2/0.5^2)
Rfcn = @(x,v,a) exp(-a.^2 -x.^2/0.5^2 - v.^2/0.5^2);

Na = length(al);
Nvl = length(vl);
Nxl = length(xl);
Q  = zeros(Na,Nvl,Nxl);

MaxEpochs = 5000;

gamma = 0.7;
indexs = 1:Na;
alpha = 1;

fig = figure(1);
clf
subplot(2,1,1)
plot(xl,Vpot(xl))
xlim([xl(1) xl(end)])
  
Vpotline = Vpot(xl);
ylim([min(Vpotline) max(Vpotline)])

hold on 

iplot = plot(0,Vpot(0),'Marker','.','Color','r','MarkerSize',30);
ylim([-9 0])
%%
[vms2,ams2,xms2] = meshgrid(vl,al,xl);
Q = 10*Rfcn(xms2,vms2,ams2);
%%
[xms,vms] = meshgrid(xl,vl);
  
[W,pi] = max(Q);
W  = reshape(W,Nvl,Nxl);
pi = reshape(pi,Nvl,Nxl);

ax_V = subplot(2,3,4);
isurf = surf(xms,vms,W,'Parent',ax_V);
view(0,90)
title('Función Valor')
shading interp
colorbar

ax_pi = subplot(2,3,5);
jsurf = surf(xms,vms,al(pi),'Parent',ax_pi);
view(0,90)
title('Politica')
shading interp
colorbar

bolean = 0*W;

ax_b = subplot(2,3,6);
T = 1;
xl_less = linspace(xl(1),xl(end),floor(Nxl/4));
vl_less = linspace(vl(1),vl(end),floor(Nvl/4));


phasep(@(s) f(s,evaluatePolicy(s,xl,vl,al,pi)),T,dt,xl_less,vl_less)
view(0,90)
title('phase portait')
shading interp
colorbar

ititle = title("epoch: "+1,'Parent',iplot.Parent);

epsilon0 = 0.99;


for iepoch = 1:MaxEpochs
    
    epsilon = epsilon0/iepoch^(1/4);
    stc = [normrnd(0.0 , 1  ,1,1) , ...
           normrnd(0.0 , 1  ,1,1)]';
    for it = 1:Nt        
        
        [~,ind_x] = min(abs(stc(1)-xl));
        [~,ind_v] = min(abs(stc(2)-vl));
        %
        bolean(ind_x,ind_v) = 1;

        % choose action
        if mod(iepoch,1000) ~= 0
            if rand < epsilon 
                ind_a = randsample(indexs,1);
            else
               Qvalue = Q(:,ind_v,ind_x);
               [Qmax,ind_a] =  max(Qvalue);
               if length(Qmax)>1
                    ind_a = randsample(indexs(Qvalue==Qmax),1);
               end
            end           
        else
            % en la animación mostramos el mejor resultado sin acciones
            % aleatorias 
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
        if mod(iepoch,1000) == 0
            if it == 1
               pause(1)

                
               [W,pi] = max(Q);
                W = reshape(W,Nvl,Nxl);
                pi = reshape(pi,Nvl,Nxl);

                isurf.ZData = W;
                jsurf.ZData = al(pi);
                
                cla
                phasep(@(s) f(s,evaluatePolicy(s,xl,vl,al,pi)),T,dt,xl_less,vl_less)


            end
            iplot.XData = stn(1);
            iplot.YData = Vpot(stn(1));
            ititle.String = "epoch: "+iepoch+" | it/Nt = "+it/Nt;
            pause(0.01)
            
        end
        %%
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
    if mod(iepoch,500) == 0
    fprintf("  epoch: "+iepoch+"\n")
    end
end


[W,pi] = max(Q);

W = reshape(W,Nvl,Nxl);
pi = reshape(pi,Nvl,Nxl);

end

