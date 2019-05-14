function axes = init_graphs_gradientmethod(iCP)

    InitialControl = iCP.Solution.ControlHistory{1};
    nY = length(iCP.Dynamics.InitialCondition);
    nU = length(InitialControl(1,:));
    TypeGraphs =  class(iCP.Dynamics);
        
   f = figure;
   FontSize  = 11;
   set(f,'defaultuipanelFontSize',FontSize)
   Ypanel = uipanel('Parent',f,'Units','norm','Pos',[0.0 0.0 1/3 1.0],'Title','State');
   Upanel = uipanel('Parent',f,'Units','norm','Pos',[1/3 0.0 1/3 1.0],'Title','Control');
   Jpanel = uipanel('Parent',f,'Units','norm','Pos',[2/3 0.0 1/3 1.0],'Title','Functional Convergence');

   switch TypeGraphs
       case 'ode'
           index = 0;
           for iY = 1:nY
              index = index + 1;
              axY{index} = subplot(nY,1,iY,'Parent',Ypanel);
              axY{index}.Title.String = ['Y_',num2str(index),'(t)'];
              axY{index}.XLabel.String = 't';
           end

           index = 0;
           for iU = 1:nU
              index = index + 1;
              axU{index} = subplot(nU,1,iU,'Parent',Upanel);
              axU{index}.Title.String = ['U_',num2str(index),'(t)'];
              axU{index}.XLabel.String = 't';
           end

       case 'pde'
            axY{1}  = subplot(2,1,1,'Parent',Ypanel);
            axY{1}.Title.String = 'Final State Vector ';
            axY{1}.XLabel.String = 'Space';
            
            axY{2}  = subplot(2,1,2,'Parent',Ypanel);
            axY{2}.Title.String = 'Evolution of State Vector';
            axY{2}.YLabel.String = 'Space';
            axY{2}.XLabel.String = 'Time';
            
            axU{1}  = subplot(2,1,1,'Parent',Upanel);
            axU{1}.Title.String = 'Final Control Vector ';
            axU{1}.XLabel.String = 'Space';
            
            axU{2}  = subplot(2,1,2,'Parent',Upanel);
            axU{2}.Title.String = 'Evolution of Control Vector';
            axU{2}.YLabel.String = 'Space';
            axU{2}.XLabel.String = 'Time';
            
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
