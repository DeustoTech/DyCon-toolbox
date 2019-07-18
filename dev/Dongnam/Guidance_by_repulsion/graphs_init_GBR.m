function axes = graphs_init_GBR(~)

   %InitialControl = iCP.Solution.ControlHistory{1};
   global M
        
   f = figure;
   FontSize  = 11;
   set(f,'defaultuipanelFontSize',FontSize)
   Ypanel = uipanel('Parent',f,'Units','norm','Pos',[0.0 0.0 1/2 1.0],'Title','State');
   Upanel = uipanel('Parent',f,'Units','norm','Pos',[1/2 0.0 1/4 1.0],'Title','Control');
   Jpanel = uipanel('Parent',f,'Units','norm','Pos',[3/4 0.0 1/4 1.0],'Title','Functional Convergence');

   axY{1}  = subplot(1,1,1,'Parent',Ypanel);
   axY{1}.Title.String = 'Dynamics';
   axY{1}.XLabel.String = 'abscissa';
   axY{1}.YLabel.String = 'ordinate';

%    axU{1}  = subplot(1,1,1,'Parent',Upanel);
%    axU{1}.Title.String = 'Control';
%    axU{1}.XLabel.String = 'Time';
%    axU{1}.YLabel.String = 'Control';
   
   index = 0;
   for iU = 1:M
      index = index + 1;
      axU{index} = subplot(M,1,iU,'Parent',Upanel);
      axU{index}.Title.String = ['U_',num2str(index),'(t)'];
      axU{index}.XLabel.String = 't';
   end
          
   axJ{1} = subplot(2,1,1,'Parent',Jpanel);
   axJ{1}.Title.String = 'J';
   axJ{1}.XLabel.String = 'iter';

   axJ{2} = subplot(2,1,2,'Parent',Jpanel);
   axJ{2}.Title.String = 'J';
   axJ{2}.XLabel.String = 'iter';
   %%
   axes.axJ = axJ;
   axes.axU = axU;
   axes.axY = axY;

%    if SaveGif
%       numbernd =  num2str(floor(100000*rand),'%.6d');
%       gif([numbernd,'.gif'],'frame',f,'DelayTime',1/2)  
%    end

end
