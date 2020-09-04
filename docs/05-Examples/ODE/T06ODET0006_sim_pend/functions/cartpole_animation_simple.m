function cartpole_animation_simple(fig,st,tspan,xx)
%CARTPOLE_ANIMATION Summary of this function goes here
%   Detailed explanation goes here
x_t = st(:,1);
theta_t     = st(:,2);


[Nt,~] = size(st);
clf
axes('Parent',fig)


yl = yline(-0.75);
yl.LineWidth = 3.0;

traj = line(x_t(1) +sin(theta_t(1)) ,cos(theta_t(1)),'Marker','.','MarkerSize',6,'Color',[1.0 0.7 0.7],'LineStyle','-');

%

lcart = line(x_t(1),0,'Marker','s','MarkerSize',30,'MarkerEdgeColor',[.6 .6 .1],'Color','r','MarkerFaceColor',[1 .6 .6]);

lcartpole = line([x_t(1),x_t(1)+sin(theta_t(1))],[0 cos(theta_t(1))], ...
                    'Marker','.', ...
                    'MarkerSize',20, ...
                    'LineWidth',4,  ...
                    'Color','k');
                


 

lhead = line(x_t(1) +sin(theta_t(1)) ,cos(theta_t(1)),'Marker','.','MarkerSize',30,'Color','r');


daspect([1 1 1])
xlim([-5 5])
ylim([-5 5])
%
tic
t = 0;
tmax = tspan(end);
while t<tmax

    t = xx*toc;
    [~, it]= min(abs(t-tspan));
    %
    lcart.XData(1) = -x_t(it);
    % arm 1
    lcartpole.XData(1) = -x_t(it);
    lcartpole.XData(2) = -x_t(it)-sin(theta_t(it));
    lcartpole.YData(2) = cos(theta_t(it));

    % head 1
    lhead.XData(1) = -x_t(it)-sin(theta_t(it));
    lhead.YData(1) = cos(theta_t(it));

    % traj
    traj.XData(end+1) = -x_t(it)-sin(theta_t(it));
    traj.YData(end+1) = cos(theta_t(it));

    
    lhead.Parent.XLim = [-7-x_t(it) 7-x_t(it)];
    
    title("t = "+num2str(t,'%.2f')+" sec")
    pause(0.01)
end

end

