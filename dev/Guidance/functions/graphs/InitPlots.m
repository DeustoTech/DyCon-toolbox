function [lem,pe,pdl,pd,RF_reco,RFax,elp] = InitPlots(State0,Ne,Nd,Ut)


[ue,~,ud,~] = state2coord(State0,Ne,Nd);

clf
fig = figure(1);
h.fig = uipanel('Parent',fig);
ax = subplot(1,2,1,'Parent',h.fig);

title(ax,Nd + " dogs vs "+Ne+" sheeps")
h.Ut = Ut;
%
xlim([-35 35])
ylim([-35 35])

[xline,yline] = plotCoVar(Uem(State0,Ne),CoUe(State0,Ne));
elp = patch(xline,yline,[0.95 0.95 0.75]);
elp.LineStyle = 'none';

uem = Uem(State0,Ne);
lem = line(uem(1),uem(2),'Color','b','Marker','o');



for i=1:Ne
    pe(i) = line(ue(1,i),ue(2,i),'Color',[0.0 0.0 1],'Marker','.','MarkerSize',8);
end
for i=1:Nd
    pdl(i) = line(ud(1,i),ud(2,i),'Color',[1 0.8 0.8],'Marker','none');
end
%
for i=1:Nd
    pd(i) = line(ud(1,i),ud(2,i),'Color',[1 0.0 0.0],'Marker','.','MarkerSize',8);
end
%
TargetPos = line(Ut.r(1),Ut.r(2),'Marker','s','color','k','MarkerSize',25);
daspect([1 1 1])
h.TargetPos = TargetPos;
h.fig.Parent.WindowButtonDownFcn = {@ButtonDown,h};



%% Q learning 

RFax = subplot(1,2,2,'Parent',h.fig);
ylim(RFax,[0 1])

RF_reco = line(0,0,'Marker','o');

title(RFax,'$J = e^{-||u_{em} - u_{Target} ||^2 - ||\Sigma||^2}$','FontWeight','normal','Interpreter','latex','FontSize',17)
xlabel('time')

    function Button(~,~,h)
        h.Ut.mode = ~h.Ut.mode;
    end
end

