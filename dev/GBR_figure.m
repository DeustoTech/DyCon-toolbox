
function [] = GBR_figure(tline,YO_tline,UO_tline,uf)
    [TN Mx] = size(UO_tline);
    [TN NN] = size(YO_tline);
    Mx = Mx/2;
    Nx = (NN - 2*Mx)/4;
    %uf = [1;1];

    %TN = length(tline); 
    dt = tline(2)-tline(1); tline = 0:dt:dt*(TN-1);
    ue_tline = reshape(YO_tline(:,1:2*Nx),[TN 2 Nx]);
    ve_tline = reshape(YO_tline(:,2*Nx+1:4*Nx),[TN 2 Nx]);
    ud_tline = reshape(YO_tline(:,4*Nx+1:4*Nx+2*Mx),[TN 2 Mx]);
    vd_tline = reshape(UO_tline,[TN 2 Mx]);
    Final_Position = reshape(ue_tline(end,:,:),[2 Nx]);
    
    % 1*dt/Np*sum(sum((X_ue(1:Nt_rbm+1,:)-uf(1)).^2+(X_ue(Nt_rbm+2:end,:)-uf(2)).^2))+10*dt/Mx*sum(U(:).^2)
    Final_Psi = 1*dt/Nx*sum(sum((ue_tline(:,1,:)-uf(1)).^2+(ue_tline(:,2,:)-uf(2)).^2,1),3);%+10*dt/Mx*sum(vd_tline(:).^2);
    %Final_Psi = mean( (Final_Position(1,:) - uf(1)).^2+(Final_Position(2,:) - uf(2)).^2 );

    Final_Reg = trapz(tline,mean(UO_tline.^2,2));


    subplot(1,2,1)
    hold on
    plot(ud_tline(:,1,1),ud_tline(:,2,1),'b-','LineWidth',1.0);
    plot(ue_tline(:,1,1),ue_tline(:,2,1),'r-','LineWidth',1.3);
    for k=2:Nx
      plot(ue_tline(:,1,k),ue_tline(:,2,k),'r-','LineWidth',1.3);
    end
    for k=2:Mx
      plot(ud_tline(:,1,k),ud_tline(:,2,k),'b-','LineWidth',1.0);
    end

    j=1;
    for k=1:Nx
      plot(ue_tline(j,1,k),ue_tline(j,2,k),'r.');
    end
    for k=1:Mx
      plot(ud_tline(j,1,k),ud_tline(j,2,k),'bs');
    end
    j=TN;
    for k=1:Nx
      plot(ue_tline(j,1,k),ue_tline(j,2,k),'ro');
    end
    for k=1:Mx
      plot(ud_tline(j,1,k),ud_tline(j,2,k),'bo');
    end
    plot(uf(1),uf(2),'ks','MarkerSize',20)

    legend('Drivers','Evaders','Location','best')
    xlabel('abscissa')
    ylabel('ordinate')
    %ylim([-2.5 1.5])
    title(['Position error = ', num2str(Final_Psi)])
    set(gca,'fontsize', 11);
    grid off

    subplot(1,2,2)
    hold on
    for k=1:Mx
        plot(tline,(vd_tline(:,1,k)+vd_tline(:,2,k))/sqrt(2),'r-','LineWidth',1.3)
        plot(tline,(-vd_tline(:,1,k)+vd_tline(:,2,k))/sqrt(2),'b-','LineWidth',1.3)
    end
    xlim([tline(1) tline(end)])
    %legend('Driver1','Driver2')
    xlabel('Time')
    ylabel('Controls')
    %title(['Total Time = ',num2str(tline(end)),' and running cost = ',num2str(Final_Reg)])
    title(['Control cost = ',num2str(Final_Reg)])
    set(gca,'fontsize', 11);
    grid on

end
