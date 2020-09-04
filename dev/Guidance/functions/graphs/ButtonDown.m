function ButtonDown(~,~,h)
    h.Ut.r = h.fig.Children(2).CurrentPoint(1,1:2)';
    h.TargetPos.XData = h.Ut.r(1);
    h.TargetPos.YData = h.Ut.r(2);
end
