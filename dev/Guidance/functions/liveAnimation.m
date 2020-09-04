function liveAnimation(F,Pi,State0,Ne,Nd,Ut)

%%

%% Graphs
[lem,pe,pdl,pd,recomp,RFax,elp] = InitPlots(State0,Ne,Nd,Ut);

epoch = 0;


Nt = 20;tspan = linspace(0,10,Nt);
options = odeset('RelTol',1e-1,'AbsTol',1e-1);


omega = 5;
gamma = 0.9;

Ntt = 100;
rt = zeros(1,Ntt);

%%

%%
while true
    
    epoch = epoch + 1;
    
    Rtotal = 0;
    
    for itt = 1:Ntt
        
        [uen,udn,stfn,stn,Jn] = ObtainEvolution(F,Pi,tspan,State0,omega,options);
        
        rt(itt) = Jn;
        
        UpdatePlots((epoch-1)*Ntt+itt,recomp,Jn,stn,Ne,Nd,pe,pd,lem,pdl,Nt,uen,udn,RFax,elp)
        
        State0 = stfn;

        pause(0.08)
    %
    end
    
    Gt = cumsum(fliplr(rt).*(gamma.^(Ntt:-1:1)));
    
    at = arrayfun(@(i) reshape(Pi(stn(i,:),omega),1,2*Nd),1:Nt,'UniformOutput',false);
    at = reshape([at{:}]',2*Nd,Nt);
end


function [ue,ud,stf,st,rt] = ObtainEvolution(F,Pi,tspan,State0,omega,options)

    %% Set Parameters
    FF = @(t,State) F(t,State,Pi,omega) ; %+ fnoise(t);

    [~,st] = ode23(FF,tspan,State0,options);

    [ue,~,ud,~] = timestate2coord(st,Ne,Nd,Nt);
    stf = st(end,:)';
    %% Cost Functional
    rt = 0;
    for it = 1:Nt
        r = norm(Ut.r-Uem(stf,Ne));
        var = norm(CoUe(stf,Ne));
        rt = rt + exp(-r^2/20^2 - var/20^2) ;
    end
    rt = rt/Nt;
end
end



