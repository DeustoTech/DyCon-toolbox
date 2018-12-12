function f2 = uAnimation(uhistory,tspan)
%UANIMATION Summary of this function goes here
%   Detailed explanation goes here
    f2 = figure;
    ax2 = axes;
    ax2.YLim = [-5 5];
    iter = length(uhistory(1,1,:));
    N = length(uhistory(1,:,1));
    
    ax2.XGrid = 'on';
    ax2.YGrid = 'on';
    for i = 1:iter-1

        for dim = 1:N
            line(tspan,uhistory(:,dim,i),'Parent',ax2)
        end
        ax2.Title.String = ['u_i(t) Evolution in iter =',num2str(i)];
        pause(0.75)
        if i~=(iter-1)
            delete(ax2.Children)
        end
    end
end

