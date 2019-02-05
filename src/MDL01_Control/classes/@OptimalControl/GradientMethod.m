function GradientMethod(iCP,varargin)
    % name: GradientMethod
    % description: The gradient method is able to optimize the given functional, going down the gradient.
    % little_description: The gradient method is able to optimize the given functional, going down the gradient.
    % autor: JOroya
    % MandatoryInputs:   
    %   iCP: 
    %       name: Control Problem
    %       description: 
    %       class: ControlProblem
    %       dimension: [1x1]
    % OptionalInputs:
    %   U0:
    %       name: Initial Control 
    %       description: matrix 
    %       class: double
    %       dimension: [length(iCP.tspan)]
    %       default: zeros
    %   MaxIter:
    %       name: Initial Control 
    %       description: matrix 
    %       class: double
    %       dimension: [1x1]
    %       default: 50
    %   tol:
    %       name: Initial Control 
    %       description: matrix 
    %       class: double
    %       dimension: 
    %       dimension: [1x1]
    %   DescentParameters:
    %       description: Parmater of Descent Method 
    %       class: double
    %       dimension: cell
    %       default: cell.empty    
    %   Graphs:
    %       description: Parameter that indicate if the method must plot the optimization, while is calculate 
    %       class: logical
    %       dimension: [1x1]
    %       default: false        
    %   TypeGraphs:
    %       description: Type of graphs. This parameter can be 'ODE' or 'PDE' 
    %       class: string
    %       dimension: [1x1]
    %       default: 'ODE'
    %   SaveGif:
    %       name: If this parameter is true, A gif of the optimization process is created
    %       description: matrix 
    %       class: double
    %       dimension: [length(iCP.tspan)]
    %       default: false
    %   restart:
    %       description: The optimization start with U0 = iCP.UOptimal
    %       class: double
    %       dimension: [1x1]
    %       default: false
    
    
    % ======================================================
    % ======================================================
    %               PARAMETERS DEFINITION
    % ======================================================
    % ======================================================
   
    %% Control Problem Parameters
    pinp = inputParser;
    addRequired(pinp,'iControlProblem')
    %%
    Udefault = zeros(length(iCP.ode.tspan),iCP.ode.Udim);
    addOptional(pinp,'U0',Udefault)
    %% Method Parameter
    addOptional(pinp,'MaxIter',200)
    addOptional(pinp,'tol',1e-2)
    addOptional(pinp,'DescentAlgorithm',@AdaptativeDescent)
    addOptional(pinp,'DescentParameters',{})
    %% Graphs Parameters
    addOptional(pinp,'Graphs',false)
    addOptional(pinp,'TypeGraphs','ODE')
    addOptional(pinp,'SaveGif',false)


    addOptional(pinp,'restart',false)

    %% 
    addOptional(pinp,'StoppingCriteria',@FunctionalStopCriteria  )

    parse(pinp,iCP,varargin{:})

    U0                  = pinp.Results.U0;
    MaxIter             = pinp.Results.MaxIter;    
    tol                 = pinp.Results.tol;
    Graphs              = pinp.Results.Graphs;
    restart             = pinp.Results.restart;
    TypeGraphs          = pinp.Results.TypeGraphs;
    SaveGif             = pinp.Results.SaveGif;
    DescentAlgorithm     = pinp.Results.DescentAlgorithm;
    DescentParameters   = pinp.Results.DescentParameters;
    % ======================================================
    % ======================================================
    %                   INIT PROGRAM
    % ======================================================
    % ======================================================
    if restart
        if ~isempty(iCP.UOptimal)
            U0 = iCP.UOptimal;
        else
            warning('The parameter restart need a previus execution.')
        end
    end
    tic;
    
    if Graphs 
        % initial axes 
        nY = length(iCP.ode.Condition);
        nU = length(U0(1,:));
        [axY,axU,axJ] = init_graphs(TypeGraphs,nY,nU,SaveGif);
    end
    
    %% Creamos un solucion vacia
    iCP.solution = CPSolution;

    iCP.solution.Yhistory = cell(1,MaxIter);
    iCP.solution.Uhistory = cell(1,MaxIter);
    iCP.solution.dJhistory = cell(1,MaxIter);

    iCP.solution.Jhistory = zeros(1,MaxIter);
    %
    iCP.solution.Uhistory{1} = U0;

        
    %% Clean the persiten variable LengthStepMemory
    clear(char(DescentAlgorithm))
    % ClassicalDescent
    % ConjugateGradientDescent
    
    
    for iter = 1:MaxIter
        % Create a funtion u(t) 
        % Update Control
        [Unew, Ynew,Jnew,dJnew,error] = DescentAlgorithm(iCP,DescentParameters{:});

        % Save history of optimization
        iCP.solution.Uhistory{iter}  = Unew;
        iCP.solution.Yhistory{iter}  = Ynew;
        iCP.solution.Jhistory(iter)  = Jnew;
        iCP.solution.dJhistory{iter} = dJnew;

        %%

        % Stopping Criteria
        if iter ~= 1 
            if Graphs   
                % plot the graphical convergence 
                bucle_graphs(axY,axU,axJ,Ynew,Unew,iCP.solution.Jhistory,iCP.ode.tspan,iter,TypeGraphs,SaveGif)
            end
            if error < tol
                  break 
            end
        end 
    end
    
    
    if iter == MaxIter 
        warning('Max iteration number reached!!')
    end
    
    iCP.solution.precision = error;
    iCP.solution.Uhistory = iCP.solution.Uhistory(1:iter);
    iCP.solution.Jhistory = iCP.solution.Jhistory(1:iter);
    iCP.solution.dJhistory = iCP.solution.dJhistory(1:iter);
    iCP.solution.Yhistory = iCP.solution.Yhistory(1:iter);

    iCP.solution.iter = iter;
    iCP.solution.time = toc; 
    
    resume(iCP.solution)
end


%% 
function [axY,axU,axJ] = init_graphs(TypeGraphs,nY,nU,SaveGif)
   f = figure;
   FontSize  = 11;
   set(f,'defaultuipanelFontSize',FontSize)
   Ypanel = uipanel('Parent',f,'Units','norm','Pos',[0.0 0.0 1/3 1.0],'Title','State');
   Upanel = uipanel('Parent',f,'Units','norm','Pos',[1/3 0.0 1/3 1.0],'Title','Control');
   Jpanel = uipanel('Parent',f,'Units','norm','Pos',[2/3 0.0 1/3 1.0],'Title','Functional Convergence');

   switch TypeGraphs
       case 'ODE'
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

       case 'PDE'
            axY = axes('Parent',Ypanel);
            axU = axes('Parent',Upanel);
   end
          
   axJ = axes('Parent',Jpanel);
   axJ.Title.String = 'J';
   axJ.XLabel.String = 'iter';
   
   if SaveGif
      numbernd =  num2str(floor(100000*rand),'%.6d');
      gif([numbernd,'.gif'],'frame',f,'DelayTime',1/2)  
   end

end
function bucle_graphs(axY,axU,axJ,Ynew,Unew,Jhistory,tspan,iter,TypeGraphs,SaveGif)

    Color = {'r','g','b','y','k','c'};
    
    switch TypeGraphs
        case 'ODE'
            iter_graph = 0;
            for iy = Ynew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                line(tspan,iy,'Parent',axY{iter_graph},'Color',Color{index_color},'LineStyle','-','Marker','.')
                if length(axY{iter_graph}.Children) > 1
                    axY{iter_graph}.Children(2).Color = 0.25*(3+axY{iter_graph}.Children(2).Color);
                    axY{iter_graph}.Children(2).Marker = 'none';


                end
            end

            iter_graph = 0;
            for iu = Unew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                line(tspan,iu,'Parent',axU{iter_graph},'Color',Color{index_color},'LineStyle','-','Marker','.')
                if length(axU{iter_graph}.Children) > 1
                    axU{iter_graph}.Children(2).Color =  0.25*(3+axU{iter_graph}.Children(2).Color);
                    axU{iter_graph}.Children(2).Marker = 'none';

                end
            end                  
        case 'PDE'
            line(1:length(Ynew(end,:)),Ynew(end,:),'Parent',axY,'Marker','.')
            if length(axY.Children) > 1
                    axY.Children(2).Color =  0.25*(3+axY.Children(2).Color);
                    axY.Children(2).Marker = 'none';
            end  
            
            line(1:length(Unew(end,:)),Unew(end,:),'Parent',axU,'Marker','.')                       
            if length(axU.Children) > 1
                    axU.Children(2).Color =  0.25*(3+axU.Children(2).Color);
                    axU.Children(2).Marker = 'none';
            end
             
            
    end


    line(0:(iter-1),Jhistory(1:iter),'Parent',axJ,'Color','b','Marker','s')

    if SaveGif
       f = axJ.Parent.Parent;
       gif('frame',f)
    end
    pause(0.1)
end




