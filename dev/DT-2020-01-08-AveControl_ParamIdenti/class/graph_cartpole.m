classdef graph_cartpole < handle
    %GRAPH_CARTPOLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lhead1
        lhead2
        traj1
        traj2
        line1
        line2
        car
        parent
        st
        t = 1;
    end
    
    methods
        function obj = graph_cartpole(axes,st)
            %GRAPH_CARTPOLE Construct an instance of this class
                        %   Detailed explanation goes here
            obj.parent = axes;
            obj.st = st;
            x_t = st(:,1);
            theta_t     = st(:,2);
            theta2_t    = st(:,3);

            yl = yline(-0.75,'Parent',axes);
            yl.LineWidth = 3.0;

 obj.traj1 = line(x_t(1) +sin(theta_t(1)) ,cos(theta_t(1)),'Marker','.','MarkerSize',6,'Color',[1.0 0.7 0.7],'LineStyle','-','Parent',axes);
            obj.traj2 = line(x_t(1)+sin(theta_t(1))+sin(theta2_t(1)) ,cos(theta_t(1))+cos(theta2_t(1)),'Marker','.','MarkerSize',6,'Color',[0.7 0.7 1.0 ],'Parent',axes);

            obj.car = line(x_t(1),0,'Marker','s','MarkerSize',30,'MarkerEdgeColor',[.6 .6 .1],'Color','r','MarkerFaceColor',[1 .6 .6],'Parent',axes);

            obj.line1 = line([x_t(1),x_t(1)+sin(theta_t(1))],[0 cos(theta_t(1))], ...
                                'Marker','.', ...
                                'MarkerSize',20, ...
                                'LineWidth',4,  ...
                                'Color','k','Parent',axes);


           obj.line2 = line([x_t(1)+sin(theta_t(1)),x_t(1)+sin(theta_t(1))+sin(theta2_t(1))],[0 cos(theta_t(1))+cos(theta2_t(1))], ...
                                'Marker','.', ...
                                'MarkerSize',20, ...
                                'LineWidth',4,  ...
                                'Color','g','Parent',axes);


            obj.lhead1 = line(x_t(1) +sin(theta_t(1)) ,cos(theta_t(1)),'Marker','.','MarkerSize',30,'Color','r','Parent',axes);
            obj.lhead2 = line(x_t(1)+sin(theta_t(1))+sin(theta2_t(1)) ,cos(theta_t(1))+cos(theta2_t(1)),'Marker','.','MarkerSize',30,'Color','r','Parent',axes);

           
        end
        
        function step(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.t = obj.t + 1;
            it = obj.t;
    
            x_t = obj.st(:,1);
            theta_t     = obj.st(:,2);
            theta2_t    = obj.st(:,3);
            
            obj.car.XData(1) = -x_t(it);
            % arm 1
            obj.line1.XData(1) = -x_t(it);
            obj.line1.XData(2) = -x_t(it)-sin(theta_t(it));
            obj.line1.YData(2) = cos(theta_t(it));
            % arm 2
            obj.line2.XData(1) = -x_t(it)-sin(theta_t(it));
            obj.line2.XData(2) = -x_t(it)-sin(theta_t(it))-sin(theta2_t(it));
            obj.line2.YData(1) = cos(theta_t(it));
            obj.line2.YData(2) = cos(theta_t(it)) + cos(theta2_t(it));
            % head 1
            obj.lhead1.XData(1) = -x_t(it)-sin(theta_t(it));
            obj.lhead1.YData(1) = cos(theta_t(it));
            % head 2
            obj.lhead2.XData(1) = -x_t(it)-sin(theta_t(it))-sin(theta2_t(it));
            obj.lhead2.YData(1) = cos(theta_t(it)) + cos(theta2_t(it));
            % traj
            obj.traj1.XData(end+1) = -x_t(it)-sin(theta_t(it));
            obj.traj1.YData(end+1) = cos(theta_t(it));
            % traj 2
            obj.traj2.XData(end+1) = -x_t(it)-sin(theta_t(it))-sin(theta2_t(it));
            obj.traj2.YData(end+1) = cos(theta_t(it)) + cos(theta2_t(it));

    
        end
        
    end
end

