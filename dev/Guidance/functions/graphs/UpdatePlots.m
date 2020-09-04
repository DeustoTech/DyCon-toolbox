function UpdatePlots(iter,recomp,rt,st,Ne,Nd,pe,pd,lem,pdl,Nt,uec,udc,RFax,elp)


    if iter < 500
        recomp.XData(end+1) = iter;
        recomp.YData(end+1) = rt; 
    else
        recomp.XData = [recomp.XData(2:end) iter];
        recomp.YData = [recomp.YData(2:end) rt];   
        xlim(RFax,[recomp.XData(1) iter])
    end
    
    for i=1:10:Nt
        
        [xline,yline] = plotCoVar(Uem(st(i,:),Ne),CoUe(st(i,:),Ne));
        elp.XData = xline;
        elp.YData = yline;
        
        uem = Uem(st(i,:),Ne);
        
        lem.XData = uem(1);
        lem.YData = uem(2);
        
        for j=1:Ne
            pe(j).XData = uec(i,1,j);
            pe(j).YData = uec(i,2,j);
        end
        for j=1:Nd
            pd(j).XData = udc(i,1,j);
            pd(j).YData = udc(i,2,j);
        end
        %%
        %Mantenemos la cola de la animacion con un maximo de 30
        if length(pdl(j).XData) < 6*Nt
            for j=1:Nd
                pdl(j).XData(end+1) = udc(i,1,j);
                pdl(j).YData(end+1) = udc(i,2,j);
            end
        else
            for j=1:Nd
                pdl(j).XData = [pdl(j).XData(2:end) udc(i,1,j)];
                pdl(j).YData = [pdl(j).YData(2:end) udc(i,2,j)];
            end    
        end
        
    end
end

